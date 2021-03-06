#' S4 class for a Veg-X measurement method definition
#'
#' @slot name Name of the measurement method.
#' @slot description Description of the measurement method.
#' @slot citationString A string with the bibliographic reference for the method.
#' @slot DOI A string with the DOI of a resource describing the method.
#' @slot subject Kind of attribute measured (e.g. 'plant cover').
#' @slot attributeType Either "quantitative", "ordinal" or "qualitative".
#' @slot attributes List of attribute values
#'
#' @references Wiser SK, Spencer N, De Caceres M, Kleikamp M, Boyle B & Peet RK (2011). Veg-X - an exchange standard for plot-based vegetation data
#'
#'
#' @examples
#' showClass("VegXMethodDefinition")
#'
setClass("VegXMethodDefinition",slots=c(
                         name = "character",
                         description="character",
                         citationString = "character",
                         DOI = "character",
                         subject = "character",
                         attributeType = "character",
                         attributes = "list"))
