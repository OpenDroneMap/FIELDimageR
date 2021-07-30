#' fieldDraw 
#' 
#' @title Making draws (lines or polygons) 
#' 
#' @description Extracting information (x, y, value) for all cells in a line or polygon. Also, this function can 
#'  be used to evaluate distances between objects or objects length.
#' 
#' @param mosaic object mask of class stack from the function \code{\link{fieldMask}}.
#' @param line if it is TRUE the selected area will be a line otherwise it will be a polygon (line=FALSE).
#' @param ndraw number of drawings (lines or polygons).
#' @param dist  if it is TRUE the distance among objects or objects length will be calculated 
#'  (mosaic should be the mask from function \code{\link{fieldMask}} and line should be line=TRUE).
#' @param distSel integer indicating which proportion of estimated distances should be selected (default 0.5). 
#'  If \code{distSel = 1} all estimated distances will be saved. Some distances can be artifacts caused by the mask 
#'  estimation and can inflate the number of distances.
#' @param round integer indicating the number of decimal places (round) or significant digits (signif) to be used.
#' @param value integer indicating the value in the mask. If value=1 the objects length will be estimated.
#'  If \code{value = 0} the distance between objects will be estimated.
#' @param pch point symbol, please check help("points").
#' @param cex character (or symbol) expansion: a numerical vector, please check help("points"). 
#' @param col color code or name, please check help("points").
#' @param lwd line width, please check help("lines").
#' 
#' @importFrom graphics par 
#'
#' @return A list four elements
#' \itemize{
#'   \item \code{drawData} is a matrix with each cell position "x" and "y" (line/polygon) and the cell value "layer".
#'   \item \code{drawObject} is the the new \code{SpatialPolygons} or \code{SpatialLines} object.
#'   \item \code{drawSegments} is a simplified drawData matrix with segments defined in paramter "value".
#'   \item \code{drawDist} is the distance or length between objects.
#' }
#'
#' @export
fieldDraw <- function(mosaic,line = TRUE, ndraw = 1, dist = FALSE, distSel = 0.5, round = 5, value = 1,
                    pch = 16, cex = 0.7, col = "red", lwd = 1) {
  mosaic <- stack(mosaic)
  num.band <- length(mosaic@layers)
  print(paste(num.band, " layer available", sep = ""))

  if(dist){
    if(!line){
      stop("For dist=T only line=TRUE can be used to evaluate distances")
    }
    if (num.band > 1) {
      stop("For dist=T only mask with values of 1 and 0 can be processed, use the mask output from fieldMask()")
    }
    if (!value %in% c(1, 0)) {
      stop("Values in the mask must be 1 or 0 to represent the objects, use the mask output from fieldMask()")
    }
    if (!all(c(raster::minValue(mosaic), raster::maxValue(mosaic)) %in%
             c(1, 0))) {
      stop("Values in the mask must be 1 or 0 to represent the objects, use the mask output from fieldMask()")
    }
    if (distSel<=0|distSel>1) {
      stop("distSel must be a vlaue between 1 or 0 ")
    }
    withr::local_par(mfrow = c(1, 2), mai = c(1, 1, 1, 1))
  } else {
    withr::local_par(mfrow = c(1, 1))
  }
  if (num.band > 2) {
    plotRGB(RGB.rescale(mosaic, num.band = 3), r = 1,
            g = 2, b = 3)
  }
  if (num.band < 3) {
    raster::plot(mosaic, col = grey(1:100/100))
  }
  print("Use the image in the plot space to draw a line/polygon (2 or more points)...")
  Out2<-list()
  for(d1 in 1:ndraw){
    print(paste("Make the draw number=", d1," and press 'ESC' when it is done.",sep=""))
    if(line){draw1<- raster::drawLine(sp = T,col = col,lwd = lwd)}
    if(!line){draw1<- raster::drawPoly(sp = T,col = col,lwd = lwd)}
    draw2 <- do.call(as.data.frame,raster::extract(x = mosaic, y = draw1,cellnumbers=TRUE))
    draw2 <- data.frame(raster::xyFromCell(object = mosaic,cell = draw2$cell),draw2)
    if (abs(max(draw2$x)-min(draw2$x)) >= abs(max(draw2$y) - min(draw2$y))) {
      ord1 <- order(draw2$x)
    }
    if (abs(max(draw2$x)-min(draw2$x)) < abs(max(draw2$y) - min(draw2$y))) {
      ord1 <- order(draw2$y)
    }
    draw2 <- draw2[ord1, ]
    Out1<-list(drawData=draw2,drawObject=draw1)
    if(dist){
      df1<-draw2[draw2$layer==value,]
      df<-draw2[draw2$layer==c(0,1)[c(0,1)!=value],]
      out <- t(sapply(1:(nrow(df)-1), function(i) {
        d <- round(stats::dist(df[i:(i+1),c("x","y")]),round)
        t <- mean(df[i:(i+1),"layer"])
        c(df[i,"x"],df[i,"y"],df[i+1,"x"],df[i+1,"y"],d,t)
      }))
      colnames(out)<-c("x1","y1","x2","y2","dist","mean")
      out<-data.frame(out)
      if (abs(max(out$x1)-min(out$x1)) >= abs(max(out$y1) - min(out$y1))) {
        ord <- order(out$x1)
      }
      if (abs(max(out$x1)-min(out$x1)) < abs(max(out$y1) - min(out$y1))) {
        ord <- order(out$y1)
      }
      out <- out[ord, ]
      freq<-table(out$dist)
      freqSel<-as.numeric(names(table(freq))[1:round(length(table(freq))*distSel,0)])
      out<-out[as.numeric(out$dist)%in%as.numeric(names(freq[freq%in%freqSel])),]
      if(d1==1){
        if (num.band > 2) {
          plotRGB(RGB.rescale(mosaic, num.band = 3), r = 1,
                  g = 2, b = 3)
        }
        if (num.band < 3) {
          raster::plot(mosaic, col = grey(1:100/100))
        }
      }
      points(df1$x,df1$y, pch = pch, cex = cex, col = col)
      Out1<-list(drawData=draw2,drawObject=draw1,drawSegments=df1,drawDist=out)
    }
    Out2[[d1]]<-Out1
  }
  names(Out2)<-paste("Draw",c(1:ndraw),sep="")
  if(ndraw==1){Out2<-Out1}
  return(Out2)
}
