#' fieldPolygon 
#' 
#' @title Building \code{shapefile} with polygons
#' 
#' @description The user should select points to make polygons in the image. Shapefile with polygons will be automatically built. 
#'  Attention: \code{fieldRotate()} is not necessary.
#'  
#'  
#' @param mosaic object of class stack.
#' @param nPolygon number of polygons.
#' @param nPoint number of points necessary to select field boundaries or area to remove (4 >= nPoint <= 50).
#' @param polygonID a vector with polygon names with same order of drawing. If is NULL the ID will be the sequence of drawing.
#' @param polygonData data frame with polygon ID and all attributes of each polygon (Traits as columns and polygon as rows).
#' @param ID the column in polygonData with polygons names (ID) which the data will be combined with fieldShape.
#' @param cropPolygon if TRUE the mosaic will be crooped using polygons shape.
#' @param remove if TRUE the selected area will be removed from the image.
#' @param plot if is TRUE the crop image and fieldShape will be plotted.
#' @param fast.plot if TRUE only the grey scale image will be plotted as reference (faster approach).
#' @param extent if is TRUE the entire image area will be the fieldShape (one unique plot).
#' 
#' @importFrom raster raster projection plotRGB res projectRaster crs extent 
#' @importFrom raster atan2 crop rasterToPolygons mask extract clump drawLine drawPoly xyFromCell
#' @importFrom graphics abline axis lines par plot points locator legend
#' @importFrom grDevices grey rgb col2rgb
#' @importFrom sp bbox Polygons Polygon SpatialPolygonsDataFrame SpatialPolygons spsample SpatialPointsDataFrame over proj4string
#' @importFrom methods as
#'
#' @return A list with two element
#' \itemize{
#'   \item The function returns the \code{fieldShape} format \code{SpatialPolygonsDataFrame} with plots 
#'   numbered by the sequence of drawings and a new reduced image with format \code{stack}. 
#'   The \code{polygonID} parameter can be used to identify each polygon.
#' }
#' 
#'
#' @export
fieldPolygon <- function(mosaic, nPolygon = 1, nPoint = 4, polygonID = NULL, polygonData = NULL, ID = NULL,
                         cropPolygon = FALSE, remove = FALSE, plot = TRUE, fast.plot = FALSE, extent = FALSE) {
  mosaic <- stack(mosaic)
  num.band <- length(mosaic@layers)
  print(paste(num.band, " layers available", sep = ""))
  if(!extent){
    if (nPoint < 4 | nPoint > 50) {
      stop("nPoint must be >= 4 and <= 50")
    }
    withr::local_par(mfrow = c(1, 2))
    if (fast.plot) {
      raster::plot(mosaic[[1]], col = grey(1:100/100), axes = FALSE, 
                   box = FALSE, legend = FALSE)
    }
    if (!fast.plot) {
      if (num.band > 2) {
        plotRGB(RGB.rescale(mosaic, num.band = 3), r = 1, 
                g = 2, b = 3)
      }
      if (num.band < 3) {
        raster::plot(mosaic, axes = FALSE, box = FALSE)
      }
    }
    for(np in 1:nPolygon){
      print(paste("Select ", nPoint, " points around of polygon (",np,") in the plots space.", 
                  sep = ""))
      c1 <- NULL
      for (i in 1:nPoint) {
        c1.1 <- locator(type = "p", n = 1, col = np, pch = 19)
        c1 <- rbind(c1, c(c1.1$x, c1.1$y))
      }
      c1 <- rbind(c1, c1[1, ])
      colnames(c1) <- c("x", "y")
      lines(c1, col = np, type = "l", lty = 2, lwd = 3)
      p1 <- Polygons(list(Polygon(c1)), "x")
      f1 <- SpatialPolygonsDataFrame(SpatialPolygons(list(p1)), 
                                     data.frame(z = 1, row.names = c("x")))
      raster::projection(f1) <- raster::projection(mosaic)
      if(np==1){fieldShape<-f1}
      if(np!=1){fieldShape<-rbind(fieldShape,f1)}
    }
    if(cropPolygon){
      print("This step takes time, please wait ... cropping")
      r <- mask(x = mosaic, mask = fieldShape, inverse = remove)
    }
    if(!cropPolygon){
      r <- crop(x = mosaic, y = fieldShape) 
    }
    r <- stack(r)
    fieldShape@data <- data.frame(polygonID = as.character(seq(1,nPolygon)))
    if (!is.null(polygonID)) {
      if (length(polygonID)!=nPolygon) {
        stop("Number of polygonID is different than nPolygon")
      }
      fieldShape@data <- data.frame(polygonID = as.character(c(t(polygonID))))
    }
    if (!is.null(polygonData)) {
      polygonData <- as.data.frame(polygonData)
      if (is.null(ID)) {
        stop("Choose one ID (column) to combine polygonData with fiedShape")
      }
      if (length(ID) > 1) {
        stop("Choose only one ID")
      }
      if (is.null(polygonID)) {
        stop("polygonID is necessary")
      }
      if (!as.character(ID) %in% as.character(colnames(polygonData))) {
        stop(paste("ID: ", ID, " is not valid."))
      }
      polygonData$polygonID <- as.character(polygonData[, colnames(polygonData) == 
                                                          ID])
      fieldShape@data <- plyr::join(fieldShape@data, polygonData, 
                                    by = "polygonID")
    }
    raster::projection(fieldShape) <- raster::projection(r)
    Out <- list(fieldShape = fieldShape, cropField = r)}
  if(extent){
    r <- stack(mosaic)
    fieldShape <- as(extent(r), 'SpatialPolygons') 
    fieldShape <- SpatialPolygonsDataFrame(fieldShape,data.frame(z = 1))
    raster::projection(fieldShape) <- raster::projection(r)
    Out <- list(fieldShape = fieldShape)
  }
  if (plot) {
    if (fast.plot) {
      raster::plot(r[[1]], col = grey(1:100/100), axes = FALSE, 
                   box = FALSE, legend = FALSE)
      sp::plot(fieldShape, add = T)
    }
    if (!fast.plot) {
      if (num.band > 2) {
        plotRGB(RGB.rescale(r, num.band = 3), r = 1, 
                g = 2, b = 3)
        sp::plot(fieldShape, add = T)
      }
      if (num.band < 3) {
        raster::plot(r, axes = FALSE, box = FALSE)
        sp::plot(fieldShape, add = T)
      }
    }
  }
  return(Out)
}
