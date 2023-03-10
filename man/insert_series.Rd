% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/insert_series.R
\name{insert_series}
\alias{insert_series}
\title{Insert Series Data}
\usage{
insert_series(serie_code, estimate, label, content, override)
}
\arguments{
\item{serie_code:}{string with code from serie to insert data}

\item{estimate:}{logical to determine if is projection to be inserted}

\item{label:}{string with label to projection}

\item{content:}{data.frame with data to be inserted, the data.frame must have only two columns:
\itemize{
\item{date: }{string with date for observation, must be in ISO format, i.e, YYYY-MM-DD}
\item{value: }{float with value for observation, must not be NA}
}}

\item{override:}{logical to determine if the repeated observations will be replaced}
}
\value{
a string with the result of operation
}
\description{
Insert serie's observations and projections
}
\examples{
\dontrun{
    response <- get_serie("AREMP0085000OOQL", FALSE)
    response <- get_serie("AREMP0085000OOQL", TRUE)
 }
}
