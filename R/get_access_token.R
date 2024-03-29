#' @title Get Auth0 acess token
#'
#' @description Gets access token for the API
#'
#' @param config_file set the user email.
#' @return auth0 token
#' @rdname get_access_token
#' @examples
#' \dontrun{
#' if(interactive()){
#'  my_token <- get_access_token()
#'  }
#' }
#' @seealso
#'  \code{\link[httr]{POST}},\code{\link[httr]{add_headers}},\code{\link[httr]{timeout}},\code{\link[httr]{content}}
#' @importFrom jsonlite fromJSON
get_access_token <- function(config_file = paste0(system.file(package = "fs4i"),"/config.json")){
  DOMAIN <- "4intelligence.auth0.com"

  if(!file.exists(config_file)){
    stop("[fs4i::login] Login to Feature Store has not been set up yet.\nPlease use function 'fs4i::login()' to authenticate.")

  } else {

    config_json <- jsonlite::fromJSON(config_file)
    access_token <- config_json[["auths"]][[DOMAIN]][["access_token"]]

    return(access_token)
  }
}
