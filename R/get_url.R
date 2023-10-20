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
    base_url <- "https://apis.4intelligence.ai/api-feature-store/api/v1/"
  } else {
    base_url <- NULL
  }

  return(paste0(base_url, endpoint))
}
