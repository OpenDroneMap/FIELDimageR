#' fieldObject 
#' 
#' @title Evaluate object area, "x" distance, "y" distance, number, extent, etc.
#' 
#' @description Calculating the object dimensions (e.g., area, "x" distance, "y" distance, number, extent, etc.) 
#'  in the entire mosaic or per plot using the \code{\link{fieldShape}} file.
#' @param mosaic object mask of class stack from the function \code{\link{fieldMask}}.
#' @param fieldShape evaluate the object per plot using the fieldShape as reference. 
#' If fieldShape=NULL, the object will be evaluated directly for the entire original image.
#' @param minArea used to set the minimum size percentage of plant canopy (to remove weeds and more).
#' @param areaValue referent value of object area in the image.
#' @param watershed if TRUE the "watershed" algorithm will be used to differentiate objects that are touching each other.
#' @param dissolve if TRUE, polygons with the same attribute value will be dissolved into multi-polygon regions. 
#'  This option requires the rgeos package.
#' @param n.rem number of objects that should be removed by decreasing size (n.rem=1 is the background).
#' @param na.rm logical. Should missing values (including NaN) be removed?.
#' @param plot if TRUE the crop image and fieldShape will be plotted.
#' 
#' @importFrom raster raster projection values
#' @importFrom methods slot 
#' @importFrom stats dist
#' 
#'@return A list with elements:
#' \itemize{
#'   \item \code{mosaic} (cropped by plot)
#'   \item \code{Dimension} (area, x.dist, y.dist)
#'   \item \code{numObjects} (number of objects)
#'   \item \code{Objects} (all objects polygon shape)
#'   \item \code{Polygons} (all extent polygons shape)
#'   \item \code{single.obj} (single object polygon shape)
#'   \item \code{obj.extent} (each object extent)
#'   \item \code{x.position} (coordinates of "x" length per object)
#'   \item \code{y.position} (coordinates of "y" length per object).
#' }
#' 
#'
#' @importFrom methods slot
#' @importFrom stats dist
#'
#'
#' @export
fieldObject <- function(mosaic, fieldShape = NULL, minArea = 0.01, areaValue = 0, watershed = FALSE, 
                        dissolve = TRUE, n.rem = 1, na.rm = FALSE, plot = TRUE) {
  mosaic <- stack(mosaic)
  num.band <- length(mosaic@layers)
  print(paste(num.band, " layer available", sep = ""))
  if (num.band > 1) {
    stop("Only mask mosaic with values of 1 and 0 can be evaluated, please use the mask output from fieldMask()")
  }
  if (!areaValue %in% c(1, 0)) {
    stop("The value must be 1 or 0 to represent the objects in the mask mosaic, please use the mask output from fieldMask()")
  }
  if (na.rm) {
    mosaic[is.na(mosaic)] <- c(0, 1)[c(0, 1) != areaValue]
  }
  print("Identifying objects ... ")
  if (is.null(fieldShape)){
    r <- stack(mosaic)
    fieldShape <- as(extent(r), "SpatialPolygons")
    fieldShape <- SpatialPolygonsDataFrame(fieldShape, data.frame(z = 1))
    raster::projection(fieldShape) <- raster::projection(r)}
  if (plot) {
    par(mfrow=c(1,1))
    raster::plot(mosaic, col = grey(1:100/100), axes = FALSE,
                 box = FALSE, legend=FALSE)
    sp::plot(fieldShape, add = T)
  }
  if(watershed){
    names(mosaic) <- "mask"
    mask <- raster::as.matrix(mosaic$mask) == areaValue
    dd <- distmap(mask)
    mosaic$watershed <- watershed(dd)
    n.obj<-unique(values(mosaic$watershed))[-1]
    if (plot) {
      par(mfrow=c(1,1))
      raster::plot(mosaic$watershed, col = grey((length(n.obj)+10):1/(length(n.obj)+10)), axes = FALSE,
                   box = FALSE, add=T, legend=FALSE)
      sp::plot(fieldShape, add = T)
    }}
  Out<-list()
  numObjects<-NULL
  for(s1 in 1:dim(fieldShape)[1]){
    single <- fieldShape[s1, ]
    CropPlot <- crop(x = mosaic, y = single)
    if(watershed){
      n.obj <- as.numeric(names(table(values(CropPlot$watershed))[order(table(values(CropPlot$watershed)),decreasing = T)]))[-c(1:n.rem)]
      SP <-rasterToPolygons(clump(CropPlot$watershed==n.obj[1]), dissolve = dissolve)
      if(length(n.obj)>1){
        for(m1 in 2:length(n.obj)){
          SP <- rbind(SP,rasterToPolygons(clump(CropPlot$watershed==n.obj[m1]), dissolve = dissolve))
        }}
      SP_df<- as.data.frame(sapply(slot(SP, "polygons"), function(x) slot(x, "ID")))
      row.names(SP_df) <- sapply(slot(SP, "polygons"), function(x) slot(x, "ID"))
      colnames(SP_df) <- "ID"
      SP <- SpatialPolygonsDataFrame(SP, data =SP_df)
    }
    if(!watershed){
      SP <- rasterToPolygons(clump(CropPlot==areaValue), dissolve = dissolve)
    }
    sps2 <- lapply(SP@polygons, function(x) SpatialPolygons(list(x)))
    print("Taking measurements...")
    obj.extent<-list()
    x.position<-list()
    y.position<-list()
    single.obj<-list()
    Dimension<-NULL
    Polygons<-NULL
    for(f1 in 1:length(sps2)){
      sps3<-sps2[[f1]]
      raster::projection(sps3)<-raster::projection(mosaic)
      P<-rasterToPolygons(raster(extent(sps3)),dissolve=TRUE)
      area<-raster::area(sps3)
      if(area>minArea){
        xy1<-cbind(x=c(extent(sps3)[c(1)],
                       extent(sps3)[c(2)]),
                   y=c(sum(extent(sps3)[c(3,4)])/2,
                       sum(extent(sps3)[c(3,4)])/2))
        xy2<-cbind(x=c(sum(extent(sps3)[c(1,2)])/2,
                       sum(extent(sps3)[c(1,2)])/2),
                   y=c(extent(sps3)[c(3)],
                       extent(sps3)[c(4)]))
        obj.extent[[f1]]<-extent(sps3)
        x.position[[f1]]<-xy1
        y.position[[f1]]<-xy2
        Dimension<-rbind(Dimension,c(area=area,x.dist=dist(xy1),y.dist=dist(xy2)))
        single.obj[[f1]]<-sps3
        if(!is.null(Polygons)){Polygons<-rbind(Polygons,P);Objects<-rbind(Objects,sps3)}
        if(is.null(Polygons)){Polygons<-P;Objects<-sps3}
        if (plot) {
          raster::plot(P, add=T, border="blue")
          lines(xy1,col="red",lty=2)
          lines(xy2,col="red",lty=2)}
      }
    }
    Objects_df<- as.data.frame(sapply(slot(Objects, "polygons"), function(x) slot(x, "ID")))
    row.names(Objects_df) <- sapply(slot(Objects, "polygons"), function(x) slot(x, "ID"))
    colnames(Objects_df) <- "ID"
    Objects <- SpatialPolygonsDataFrame(Objects, data =Objects_df)
    Polygons_df<- as.data.frame(sapply(slot(Polygons, "polygons"), function(x) slot(x, "ID")))
    row.names(Polygons_df) <- sapply(slot(Polygons, "polygons"), function(x) slot(x, "ID"))
    colnames(Polygons_df) <- "ID"
    Polygons <- SpatialPolygonsDataFrame(Polygons, data =Polygons_df)
    print(paste("number of objects on plot ",s1,": ",length(Objects),sep = ""))
    if(dim(fieldShape)[1]==1){Out<-list(mosaic=mosaic,Dimension=as.data.frame(Dimension),numObjects=c(numObjects,length(Objects)),Objects=Objects,Polygons=Polygons,single.obj=single.obj,obj.extent=obj.extent,x.position=x.position,y.position=y.position)}
    if(dim(fieldShape)[1]!=1){Out[[s1]]<-list(mosaic=CropPlot,Dimension=as.data.frame(Dimension),numObjects=c(numObjects,length(Objects)),Objects=Objects,Polygons=Polygons,single.obj=single.obj,obj.extent=obj.extent,x.position=x.position,y.position=y.position)}
  }
  if(dim(fieldShape)[1]!=1){names(Out)<-fieldShape$fieldID}
  if(dim(fieldShape)[1]!=1){if("PlotName"%in%as.character(names(fieldShape))){names(Out)<-fieldShape$PlotName}}
  return(Out)
}
