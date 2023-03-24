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
    base_url <- "https://run-prod-4casthub-featurestore-api-zdfk3g7cpq-ue.a.run.app/api/v1/"
  } else if(api == "data-loader") {
    base_url <- "https://run-prod-fs-data-loader-api-zdfk3g7cpq-ue.a.run.app/api/v1/"
  }

  return(paste0(base_url, endpoint))
}
