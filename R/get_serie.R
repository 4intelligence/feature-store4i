#' @title Get Serie Data
#'
#' @description Gets serie observations and metadata
#'
#' @param serie_code: code from serie to fetch
#' @param estimate: logical to include or not projection from serie
#' @return a list with two dataframes, the first one is the serie's data and the second one is the serie's metadata.
#' @rdname get_serie
#' @examples
#' \dontrun{
#'     response <- get_serie("AREMP0085000OOQL", FALSE)
#'     response <- get_serie("AREMP0085000OOQL", TRUE)
#'  }
#' @export

fix_null = function(value) {
  if(is.null(value)) {
    return(NA)
  }
  return(value)
}

fix_null_obs = function(value) {
  if(is.null(value)) {
    return(NA_real_)
  }
  return(value)
}

get_serie <- function(serie_code, estimate) {
  access_token <- get_access_token()
  headers <- c("authorization"= paste0("Bearer ", access_token))
  headers <- httr::insensitive(headers)

  # Request series metadata
  endpoint_metadata <- paste0("series/", serie_code)
  url <- get_url(endpoint_metadata, "fs")

  message("[fs4i::get_serie] Requesting data for ", serie_code)
  # Pause for 1 second to comply with rate limit
  # Sys.sleep(1)

  series_metadata <- NULL
  response <- httr::GET(url, httr::add_headers(.headers=headers))
  if(response$status_code == 401) {
    stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\nInvalid Authentication.\nYou should try fs4i::login()")
  } else if(response$status_code == 404) {
    stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\n", serie_code, " is not available on Feature Store.")
  } else if(response$status_code == 429) {
    stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\nToo many requests, rate limit exceeded! Try again in a minute.")
  } else if(response$status_code >= 400) {
    stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\nAn error ocurred during the request.")
  } else {
    list_metadata <- httr::content(response)$data

    series_metadata <- data.frame(
      name=data.frame("en_us"=fix_null(list_metadata$name$`en-us`), "pt_br"=fix_null(list_metadata$name$`pt-br`)),
      source=fix_null(list_metadata$source),
      code=fix_null(list_metadata$code),
      indicator_code=fix_null(list_metadata$indicator_code),
      date_start_projection=fix_null(list_metadata$date_start_projection),
      date_end_projection=fix_null(list_metadata$date_end_projection),
      date_start=fix_null(list_metadata$date_start),
      date_end=fix_null(list_metadata$date_end),
      region=data.frame("en_us"=fix_null(list_metadata$region$`en-us`), "pt_br"=fix_null(list_metadata$region$`pt-br`)),
      aggregation=data.frame("en_us"=fix_null(list_metadata$aggregation$`en-us`), "pt_br"=fix_null(list_metadata$aggregation$`pt-br`)),
      primary_transformation=data.frame("en_us"=fix_null(list_metadata$primary_transformation$`en-us`), "pt_br"=fix_null(list_metadata$primary_transformation$`pt-br`)),
      second_transformation=data.frame("en_us"=fix_null(list_metadata$second_transformation$`en-us`), "pt_br"=fix_null(list_metadata$second_transformation$`pt-br`)),
      last_updated=fix_null(list_metadata$last_updated),
      unit=data.frame("en_us"=fix_null(list_metadata$unit$`en-us`), "pt_br"=fix_null(list_metadata$unit$`pt-br`)),
      tag=fix_null(list_metadata$tag),
      is_dummy=fix_null(list_metadata$is_dummy)
    )
  }

  # Request series observations
  observations <- data.frame(date=c(), value=c())

  endpoint_observations <- paste0("indicators/", series_metadata$indicator_code, "/series/", serie_code, "/observations")
  url <- get_url(endpoint_observations, "fs")
  params <- "?limit=2000&skip="

  # Pause for 1 second to comply with rate limit
  # Sys.sleep(1)
  request_url <- paste0(url, params, "0")
  response <- httr::GET(request_url, httr::add_headers(.headers=headers))

  if(response$status_code == 429) {
    stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\nToo many requests, rate limit exceeded! Try again in a minute.")
  } else {
    r_content <- httr::content(response)
    total <- as.integer(r_content$total)

    if(total == 0) {
      stop("[fs4i::get_serie] ", serie_code, " is empty.")
    }

    temp_observations <- data.frame(t(do.call(cbind, r_content$data)))
    observations <- rbind(observations, temp_observations)
    while(length(observations$date) < total) {
      skip <- length(observations$date)
      request_url <- paste0(url, params, skip)
      # Pause for 1 second to comply with rate limit
      # Sys.sleep(1)
      response <- httr::GET(request_url, httr::add_headers(.headers=headers))

      if(response$status_code == 429) {
        stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\nToo many requests, rate limit exceeded! Try again in a minute.")
      }

      r_content <- httr::content(response)
      temp_observations <- data.frame(t(do.call(cbind, r_content$data)))
      observations <- rbind(observations, temp_observations)
    }

    observations$value <- lapply(observations$value, fix_null_obs)
  }

  if(!estimate) {
    return(list(observations, series_metadata))
  }

  # Request series projections
  projections <- data.frame(date=c(), value=c())

  endpoint_projections <- paste0("indicators/", series_metadata$indicator_code, "/series/", serie_code, "/projections")
  url <- get_url(endpoint_projections, "fs")
  params <- "?limit=2000&skip="

  request_url <- paste0(url, params, "0")
  # Pause for 1 second to comply with rate limit
  # Sys.sleep(1)
  response <- httr::GET(request_url, httr::add_headers(.headers=headers))

  if(response$status_code == 429) {
    stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\nToo many requests, rate limit exceeded! Try again in a minute.")
  } else {
    r_content <- httr::content(response)
    total <- as.integer(r_content$total)

    if(total == 0) {
      observations$estimated = FALSE
      return(list(observations, series_metadata))
    }

    temp_projections <- data.frame(t(do.call(cbind, r_content$data)))
    projections <- rbind(projections, temp_projections)
    while(length(projections$date) < total) {
      skip <- length(projections$date)
      request_url <- paste0(url, params, skip)
      # Pause for 1 second to comply with rate limit
      # Sys.sleep(1)
      response <- httr::GET(request_url, httr::add_headers(.headers=headers))

      if(response$status_code == 429) {
        stop("[fs4i::get_serie] API Status Code: ", response$status_code, ".\nToo many requests, rate limit exceeded! Try again in a minute.")
      }

      r_content <- httr::content(response)
      temp_projections <- data.frame(t(do.call(cbind, r_content$data)))
      projections <- rbind(projections, temp_projections)
    }

    projections$value <- lapply(projections$value, fix_null_obs)
  }

  observations$estimated = FALSE
  projections$estimated = TRUE

  obs_dates <- list(observations$date)
  last_date <- sapply(obs_dates, tail, 1)

  if(is.character(last_date) == FALSE){
    last_date <- sapply(last_date, tail, 1)
  }

  filtered_projections <- projections[projections$date > last_date,]
  complete_df <- rbind(observations, filtered_projections)
  complete_df <- complete_df[!duplicated(complete_df$date), ]

  return(list(complete_df, series_metadata))
}

