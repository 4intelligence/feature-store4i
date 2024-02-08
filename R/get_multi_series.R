#' @title Get Multi Series Data
#'
#' @description Gets multiple series observations and metadata
#'
#' @param series_code: a vector with codes from series to fetch
#' @param estimate: logical to include or not projection from series
#' @return a list with two dataframes, the first one is the series data and the second one is the series metadata.
#' @rdname get_multi_series
#' @examples
#' \dontrun{
#'     response <- get_multi_series(c("AREMP0085000OOQL", "BRBOP0044000OOML"), FALSE)
#'     response <- get_multi_series(c("AREMP0085000OOQL", "BRBOP0044000OOML"), TRUE)
#'  }
#' @export
get_multi_series <- function(series_code, estimate) {
  df_observations <- data.frame(date=c(), value=c(), serie=c())
  if(estimate) {
    df_observations$estimated = NULL
  }

  df_metadata <- data.frame(
    name=c(),
    source=c(),
    code=c(),
    indicator_code=c(),
    date_start_projection=c(),
    date_end_projection=c(),
    date_start=c(),
    date_end=c(),
    region=c(),
    aggregation=c(),
    primary_transformation=c(),
    second_transformation=c(),
    last_updated=c(),
    unit=c(),
    tag=c(),
    is_dummy=c()
  )

  for (serie_code in series_code) {
    response <- try(get_serie(serie_code, estimate))
    if (inherits(response, 'try-error')) {
      message("[fs4i::get_multi_series] Skipping ", serie_code, ".")
    } else {
      data <- response[[1]]
      metadata <- response[[2]]

      data$serie <- metadata$code
      df_observations <- rbind(df_observations, data)
      df_metadata <- rbind(df_metadata, metadata)
    }
  }

  return(list(df_observations, df_metadata))
}
