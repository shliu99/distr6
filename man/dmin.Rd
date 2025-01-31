% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Distribution.R
\name{dmin}
\alias{dmin}
\title{Distribution Minimum Accessor}
\usage{
dmin(object)
}
\arguments{
\item{object}{Distribution.}
}
\description{
Returns the distribution minimum as the minimum of the support. If the support is not
bounded below then minimum is given by
\deqn{minimum = infimum + 2.220446e-16}
}
\section{R6 Usage}{
 $dmin()
}

\seealso{
\code{\link{support}}, \code{\link{dmax}}, \code{\link{sup}}, \code{\link{inf}}
}
