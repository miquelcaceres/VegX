% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/VegXMethodDefinition.R
\docType{class}
\name{VegXMethodDefinition-class}
\alias{VegXMethodDefinition-class}
\title{S4 class for a Veg-X measurement method definition}
\description{
S4 class for a Veg-X measurement method definition
}
\section{Slots}{

\describe{
\item{\code{name}}{Name of the measurement method.}

\item{\code{description}}{Description of the measurement method.}

\item{\code{citationString}}{A string with the bibliographic reference for the method.}

\item{\code{DOI}}{A string with the DOI of a resource describing the method.}

\item{\code{subject}}{Kind of attribute measured (e.g. 'plant cover').}

\item{\code{attributeType}}{Either "quantitative", "ordinal" or "qualitative".}

\item{\code{attributes}}{List of attribute values}
}}

\examples{
showClass("VegXMethodDefinition")

}
\references{
Wiser SK, Spencer N, De Caceres M, Kleikamp M, Boyle B & Peet RK (2011). Veg-X - an exchange standard for plot-based vegetation data
}
