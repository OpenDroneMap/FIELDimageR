#' fieldPlot 
#' 
#' @title Plot of fieldShape file filled with trait value for each plot
#' 
#' @description Graphic visualization of trait values for each plot using the \code{\link{fieldShape}} file and original image. 
#' @param fieldShape plot shape file, please use first the function getInfo().
#' @param fieldAttribute attribute or trait which the values will fill the plots, please use first the function getInfo().
#' @param mosaic object of class stack that is not necessary, but if provided will be plotted with the fieldShape file.
#' @param color colors to interpolate, must be a valid argument.
#' @param min.lim lowest limit of the color range. If is NULL the lowest value of the data will be used.
#' @param max.lim upper limit of the color range. If is NULL the highest value of the data will be used.
#' @param alpha transparency with values between 0 and 1.
#' @param legend.position legend position.
#' @param na.color color of missing values "NA".
#' @param classes number of classes at the legend.
#' @param round number of decimal digits at the legend.
#' @param horiz if TRUE will plot a horizontal legend.
#' 
#' @importFrom grDevices colorRamp
#' 
#' @return A list with two element
#' \itemize{
#'   \item The function returns a image with the \code{fieldShape} file filled with trait value for each plot.
#' }
#' 
#'
#' @export
fieldPlot <- function(fieldShape, fieldAttribute, mosaic = NULL, color=c("white","black"), min.lim = NULL, max.lim = NULL, 
                      alpha = 0.5, legend.position = "right", na.color = "gray", classes = 5, round = 3, horiz = FALSE) {
  if(length(fieldAttribute)>1){stop("Choose ONE attribute")}
  attribute<-colnames(fieldShape@data)
  if(!fieldAttribute%in%attribute){stop(paste("Attribute ",fieldAttribute," is not valid. Choose one among: ", unique(attribute), sep = ""))}
  val<-as.numeric(fieldShape@data[,which(attribute%in%fieldAttribute)[1]])
  if(!c(is.null(min.lim)&is.null(max.lim))){
    if (!c(is.numeric(min.lim)&is.numeric(max.lim))) {
      stop("Limit need to be numeric e.g. min.lim=0 and max.lim=1")
    }
    if (min.lim > min(val, na.rm = T)) {
      stop(paste("Choose minimum limit (min.lim) equal or lower than ",min(val,na.rm = T), sep=""))
    }
    if (max.lim < max(val, na.rm = T)) {
      stop(paste("Choose maximum limit (max.lim) equal or greater than ",max(val,na.rm = T), sep=""))
    }
    val<-c(min.lim,val,max.lim)
  }
  na.pos<-is.na(val)
  rr <- range(val,na.rm=T)
  svals <- (val-rr[1])/diff(rr)
  f <- colorRamp(color)
  svals[na.pos] <- 0
  valcol <- rgb(f(svals)/255, alpha = alpha)
  valcol[na.pos] <- rgb(t(col2rgb(col = na.color, alpha = FALSE))/255,alpha = alpha)
  if(!c(is.null(min.lim)&is.null(max.lim))){valcol<-valcol[-c(1,length(valcol))]}
  if(!is.null(mosaic)){
    if(projection(fieldShape)!=projection(mosaic)){stop("fieldShape and mosaic must have the same projection CRS. Use fieldRotate() for both files.")}
    mosaic <- stack(mosaic)
    num.band<-length(mosaic@layers)
    if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}
    sp::plot(fieldShape, col= valcol, add = T)
  }
  if(is.null(mosaic)){
    sp::plot(fieldShape, col= valcol)}
  pos <- round(seq(min(val,na.rm = T), max(val,na.rm = T), length.out = classes),round)
  if(any(na.pos)){pos=c(pos,"NA")}
  col<-rgb(f(seq(0, 1, length.out = classes))/255, alpha = alpha)
  if(any(na.pos)){col=c(col,rgb(t(col2rgb(col = na.color, alpha = FALSE))/255,alpha = alpha))}
  legend(legend.position,
         title= fieldAttribute,
         legend = pos,
         fill =  col,
         bty = "n",
         horiz = horiz)
}
