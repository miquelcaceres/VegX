#' Add a Taxon by Site table
#'
#' Adds the aggregated organism observations of a taxon-by-site table to an existing VegX object.
#' Data can be added to an existing project or a new project can be defined within the VegX object,
#' depending on the input project title.
#' Vegetation plots and taxon names can be the same as those already existing in the target VegX.
#' Plot observations, however, are always considered new.
#'
#' @param target the original object of class \code{\linkS4class{VegX}} to be modified
#' @param x site-by-species releve table
#' @param projectTitle a character string to identify the project title, which can be the same as one of the currently defined in \code{target}.
#' @param method measurement method for aggregated plant abundance (an object of class \code{\linkS4class{VegXMethod}}).
#' @param obsDates a vector of \code{\link{Date}} objects with plot observation dates.
#' @param absence.values a vector of values to be interpreted as missing plant information.
#' @param verbose flag to indicate console output of the data integration process.
#'
#' @return an object of class \code{\linkS4class{VegX}}
#' @export
#'
#' @examples
addTaxonBySiteData <-function(target,
                              x,
                              projectTitle,
                              method = defaultPercentCoverMethod(),
                              obsDates = Sys.Date(), absence.values = c(NA, 0),
                              verbose = TRUE) {

  #get project ID and add new project if necessary
  nprid = .newProjectIDByTitle(target,projectTitle)
  projectID = nprid$id
  if(nprid$new) {
    target@projects[[projectID]] = list("title" = projectTitle)
    if(verbose) cat(paste0(" New project '", projectTitle,"' added.\n"))
  } else {
    if(verbose) cat(paste0(" Data will be added to existing project '", projectTitle,"'.\n"))
  }

  #plots
  orinplots = length(target@plots)
  nplot = nrow(x)
  plotIDs = character(0)
  plotNames = rownames(x)
  for(i in 1:nplot) {
    npid = .newPlotIDByName(target, plotNames[i]) # Get the new plot ID (internal code)
    plotIDs[i] = npid$id
    if(npid$new) target@plots[[plotIDs[i]]] = list("plotName" = plotNames[i])
  }
  finnplots = length(target@plots)
  if(verbose) {
    cat(paste0(" ", finnplots-orinplots, " new plots added.\n"))
  }

  #plot observations
  if(length(obsDates)==1) obsDates = rep(obsDates, nplot)
  orinpobs = length(target@plotObservations)
  plotObsIDs = as.character((orinpobs+1):(orinpobs+nplot))
  for(i in 1:nplot) target@plotObservations[[plotObsIDs[i]]] = list("plotID" = plotIDs[i],
                                                          "obsStartDate" = obsDates[i],
                                                          "projectID" = projectID)
  finnpobs = length(target@plotObservations)
  if(verbose) {
    cat(paste0(" ", finnpobs-orinpobs, " new plot observations added.\n"))
  }


  # #taxon name usage concepts
  orintuc = length(target@taxonNameUsageConcepts)
  tnucNames = colnames(x)
  ntnuc = length(tnucNames)
  tnucIDs = character(0)
  for(i in 1:ntnuc) {
    print(tnucNames[i])
    ntnucid = .newTaxonNameUsageConceptIDByName(target, tnucNames[i]) # Get the new taxon name usage ID (internal code)
    tnucIDs[i] = ntnucid$id
    if(ntnucid$new) target@taxonNameUsageConcepts[[tnucIDs[i]]] = list("authorName" = tnucNames[i])
  }
  finntuc = length(target@taxonNameUsageConcepts)
  if(verbose) {
    cat(paste0(" ", finntuc-orintuc, " new taxon name usage concepts added.\n"))
  }

  #methods/attributes (WARNING: method match should be made by attributes?)
  nmtid = .newMethodIDByName(target,method@name)
  methodID = nmtid$id
  if(nmtid$new) {
    target@methods[[methodID]] = list(name = method@name,
                                      description = method@description,
                                      attributeClass = method@attributeClass,
                                      attributeType = method@attributeType)
    if(verbose) cat(paste0(" Measurement method '", method@name,"' added.\n"))
    # add attributes if necessary
    cnt = length(target@attributes)+1
    for(i in 1:length(method@attributes)) {
      attid = as.character(cnt)
      target@attributes[[attid]] = method@attributes[i]
      target@attributes[[attid]]$methodID = methodID
      cnt = cnt + 1
    }
    nattr = length(method@attributes)
  }

  if(method@attributeType!= "quantitative") {
    nattr = length(method@attributes)
    codes = character(nattr)
    ids = names(method@attributes)
    for(i in 1:nattr) codes[i] = as.character(method@attributes[[i]]$code)
  }

  # aggregated organism observations
  # absence.values = as.character(absence.values)
  # aggObsCounter = 1 #counter
  # aggObsVector = vector("list",0)
  # for(i in 1:nplot) {
  #   for(j in 1:ntnuc) {
  #     if(!(as.character(x[i,j]) %in% absence.values)) {
  #       if(method@attributeType== "quantitative") {
  #         attID = "1"
  #         if(x[i,j]> method@attributes[[1]]$upperBound) {
  #           stop(paste0("Value '", x[i,j],"' larger than upper bound of measurement definition. Please revise scale or data."))
  #         }
  #         else if(x[i,j] < method@attributes[[1]]$lowerBound) {
  #           stop(paste0("Value '", x[i,j],"' smaller than lower bound of measurement definition. Please revise scale or data."))
  #         }
  #       } else {
  #         ind = which(codes==as.character(x[i,j]))
  #         if(length(ind)==1) attID = ids[ind]
  #         else stop(paste0("Value '", x[i,j],"' not found in measurement definition. Please revise scale or data."))
  #       }
  #       aggObsVector[[aggObsCounter]] = list("plotObservationID" = plotObsIDs[i],
  #                                       "taxonNameUsageConceptID" = tnucIDs[j],
  #                                       "attributeID" = attID,
  #                                       "value" = x[i,j])
  #       aggObsCounter = aggObsCounter + 1
  #     }
  #   }
  # }
  #
  return(target)
}