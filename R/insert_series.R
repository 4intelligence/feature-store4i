#' @title Insert Series Data
#'
#' @description Insert serie's observations and projections
#'
#' @param serie_code: string with code from serie to insert data
#' @param estimate: logical to determine if is projection to be inserted
#' @param label: string with label to projection
#' @param content: data.frame with data to be inserted, the data.frame must have only two columns:
#' \itemize{
#' \item{date: }{string with date for observation, must be in ISO format, i.e, YYYY-MM-DD}
#' \item{value: }{float with value for observation, must not be NA}
#' }
#' @param override: logical to determine if the repeated observations will be replaced
#'
#' @return a string with the result of operation
#' @rdname insert_series
#' @examples
#' \dontrun{
#'     response <- get_serie("AREMP0085000OOQL", FALSE)
#'     response <- get_serie("AREMP0085000OOQL", TRUE)
#'  }
#' @export
insert_series <- function(serie_code, estimate, label, content, override) {
  access_token <- get_access_token()
  headers <- c("authorization"= paste0("Bearer ", access_token))
  headers <- httr::insensitive(headers)

  # Validate projection
  if(estimate && label == "") {
    return("The label must be set when estimate is TRUE")
  }

  # Validate content
  if(!("date" %in% names(content)) || !("value" %in% names(content))) {
    return("Invalid columns in content, must be 'date' and 'value'")
  }

  # Validate date
  check_date <- as.Date(content$date, format="%Y-%m-%d")
  if(anyNA(check_date)) {
    return("There are invalid date(s) in content")
  }

  # Check for NA
  if(anyNA(content)) {
    return("There are NA(s) in content")
  }

  url <- get_url("tasks/series", "data-loader")

  # Prepare body to POST
  names(content)[names(content) == "value"] <- "val"

  body <- list(
    uid="",
    pwd="",
    sid=serie_code,
    ag="Geral",
    est=estimate,
    lbl=label,
    ovr=override,
    contents=content
  )

  bodyJSON <- jsonlite::toJSON(body, auto_unbox = TRUE)

  response <- httr::POST(
    url,httr::add_headers(headers), body=bodyJSON
  )

  if(response$status_code == 200) {
    return("Request created with success, data will be proccessed")
  } else {
    message("API Status: ", response$status_code)
    return("Error to proccess request")
  }
}

