#' @title Getting url for modeling
#'
#' @description Getting url for FaaS modeling.
#'
#' @return Api url.
#' @details DETAILS
#' @examples
#' \dontrun{
#' url <- get_url("series")
#' }
#' @rdname get_url
#' @param endpoint endpoint to access resource
get_url <- function(endpoint, api) {

  if(api == "fs") {
    base_url <- "https://4i-featurestore-prod-api.azurewebsites.net/api/v1/"
  } else if(api == "data-loader") {
    base_url <- "https://fs-data-loader-api-co6be3hgrq-uc.a.run.app/api/v1/"
  }

  return(paste0(base_url, endpoint))
}
