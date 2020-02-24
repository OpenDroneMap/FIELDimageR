polygonShape<-function(mosaic,nPolygon=1,nPoint=4,polygonID=NULL,polygonData=NULL,ID=NULL,cropPolygon=F,remove=F,plot=T,fast.plot=F){
  source(file = system.file("extdata", "RGB.rescale.R", package = "FIELDimageR", 
                            mustWork = TRUE))
  mosaic <- stack(mosaic)
  num.band <- length(mosaic@layers)
  print(paste(num.band, " layers available", sep = ""))
  if (nPoint < 4 | nPoint > 50) {
    stop("nPoint must be >= 4 and <= 50")
  }
  par(mfrow = c(1, 2))
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
    projection(f1) <- projection(mosaic)
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
  projection(fieldShape) <- projection(r)
  Out <- list(fieldShape = fieldShape, cropField = r)
  par(mfrow = c(1, 1))
  return(Out)
}

