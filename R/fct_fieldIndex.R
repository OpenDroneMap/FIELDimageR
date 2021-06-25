#' fieldIndex 
#' 
#' @title Building vegetation indices using Red, Green, Blue, Red Edge, and NIR band
#' 
#' @description Different vegetation indices can be calculated using at least 3 bands. 
#' For the list of indices please visit the FIELDimageR manual at link
#' 
#' @param mosaic object of class stack with at least 3 bands.
#' @param Red vector with the vegetation indices to be calculated. 
#' @param Green user can calculate a diferent index using the bands names, e.g. "(Green+Blue)/Red-NIR/RedEdge"
#' @param Blue if is TRUE the original and crop image will be plotted.
#' @param RedEdge vector with the vegetation indices to be calculated. 
#' @param NIR if is TRUE the original and crop image will be plotted.
#' @param index vector with the vegetation indices to be calculated. 
#' @param myIndex user can calculate a diferent index using the bands names, e.g. "(Green+Blue)/Red-NIR/RedEdge"
#' @param plot if is TRUE the original and crop image will be plotted.
#' 
#' @importFrom graphics par
#' @importFrom utils read.csv
#' 
#' @return A Image format stack.
#'
#' @export
fieldIndex <- function(mosaic, Red = 1, Green = 2, Blue = 3, RedEdge = NULL, NIR = NULL, index = "HUE",
                       myIndex = NULL, plot = TRUE) {
  Ind <- read.csv(file=system.file("extdata", "Indices.txt", package = "FIELDimageR", mustWork = TRUE),
                  header = TRUE, sep = "\t")
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layers available", sep = ""))
  if(num.band<3){stop("At least 3 bands (RGB) are necessary to calculate indices")}
  if(!is.null(RedEdge)|!is.null(NIR)){
    if(num.band<4){
      stop("RedEdge and/or NIR is/are not available in your mosaic")
    }}
  IRGB = as.character(Ind$index)
  if(is.null(index)){stop("Choose one or more indices")}
  if(!all(index%in%IRGB)){stop(paste("Index: ",index[!index%in%IRGB]," is not available in FIELDimageR"))}
  NIR.RE<-as.character(Ind$index[Ind$band%in%c("RedEdge","NIR")])
  if(any(NIR.RE%in%index)&is.null(NIR)){stop(paste("Index: ",NIR.RE[NIR.RE%in%index]," needs NIR/RedEdge band to be calculated",sep = ""))}
  B<-mosaic@layers[[Blue]]
  G<-mosaic@layers[[Green]]
  R<-mosaic@layers[[Red]]
  names(mosaic)[c(Blue,Green,Red)]<-c("Blue","Green","Red")
  if(!is.null(RedEdge)){
    RE<-mosaic@layers[[RedEdge]]
    names(mosaic)[RedEdge]<-c("RedEdge")
  }
  if(!is.null(NIR)){
    NIR1<-mosaic@layers[[NIR]]
    names(mosaic)[NIR]<-c("NIR")
  }
  for(i in 1:length(index)){
    mosaic@layers[[(num.band+i)]]<-eval(parse(text = as.character(Ind$eq[as.character(Ind$index)==index[i]])))
    names(mosaic)[(num.band+i)]<-as.character(index[i])
  }
  if(!is.null(myIndex)){
    Blue<-B
    Green<-G
    Red<-R
    if(!is.null(NIR)){NIR<-NIR1}
    if(!is.null(RedEdge)){RedEdge<-RE}
    for(m1 in 1:length(myIndex)){
      mosaic@layers[[(length(mosaic@layers) + 1)]] <- eval(parse(text = as.character(myIndex[m1])))
      if(length(myIndex)==1){names(mosaic)[(length(mosaic@layers))] <- "myIndex"}
      if(length(myIndex)>1){names(mosaic)[(length(mosaic@layers))] <- paste("myIndex", m1)}
    }
  }
  if(plot){raster::plot(mosaic, axes=FALSE, box=FALSE)}
  mosaic <- stack(mosaic)
  return(mosaic)
}
