#' fieldMap 
#' 
#' @title Organazing the field map in function of plot order.
#' 
#' @description Field map ID identification to align with plots shapefile built with fieldShape(). The plots are numbered from left to right and top to bottom.
#' 
#' @param fieldPlot vector with plot ID
#' @param fieldColumn vector with column ID
#' @param fieldRow vector with row ID
#' @param decreasing if FALSE the plots will be order left to right and right to left every other line following the breeding field design.
#' 
#'@return 
#' \itemize{
#'   \item The function returns a matrix with plots ID identified by rows and column
#' }
#' 
#'
#' @export
fieldMap <- function(fieldPlot, fieldColumn, fieldRow, decreasing = FALSE){
  if(length(fieldPlot)!=length(fieldRow)|length(fieldPlot)!=length(fieldColumn)|length(fieldColumn)!=length(fieldRow)){
    stop("Plot, Column and Row vectors must have the same length.")
  }
  map <- NULL
  for(i in 1:length(fieldRow)){
    r1<-as.character(fieldPlot[fieldRow==i][order(as.numeric(fieldColumn[fieldRow==i]),decreasing = decreasing)])
    map<-rbind(map,r1)
  }
  colnames(map) <- NULL
  rownames(map) <- NULL
  return(as.matrix(map))
}
