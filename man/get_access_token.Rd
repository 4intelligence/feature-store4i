% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_access_token.R
\name{get_access_token}
\alias{get_access_token}
\title{Get Auth0 acess token}
\usage{
get_access_token(
  config_file = paste0(system.file(package = "fs4i"), "/config.json")
)
}
\arguments{
\item{config_file}{set the user email.}
}
\value{
auth0 token
}
\description{
Gets access token for the API
}
\examples{
\dontrun{
if(interactive()){
 my_token <- get_access_token()
 }
}
}
\seealso{
\code{\link[httr]{POST}},\code{\link[httr]{add_headers}},\code{\link[httr]{timeout}},\code{\link[httr]{content}}
}
