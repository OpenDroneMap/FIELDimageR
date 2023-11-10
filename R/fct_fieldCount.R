#' fieldCount 
#' 
#' @title Calculating number of objects per plot
#' 
#' @description The mask from function \code{\link{fieldMask}} is used to identify the number of objects per plot..
#' 
#' @param mosaic object mask of class stack from the function \code{\link{fieldMask}}.
#' @param fieldShape plot shape file.
#' @param watershed TRUE (defaut) or FALSE. Use or not watershed to identify objects. Otherwise, all touching objects will be considered as one polygon.
#' @param plot if it is TRUE the original and segmented image will be plotted with identified objects. 
#' @param pch point symbol, please check \code{help("points")}.
#' @param col color code or name, please check \code{help("points")}.
#' 
#' @importFrom EBImage distmap watershed
#' @importFrom terra ifel is.bool crds as.array
#' @importFrom dplyr summarize group_by n
#' 
#' @return A list with two elements when fieldShape is provided:
#' \itemize{
#'   \item \code{fieldShape$plot_level} is the new shapeFile with objects in the plot area, perimeter, count, and mean_width.
#'   \item \code{fieldShape$object_level} is the new shapeFile of single objects area, perimeter, width, x and y position.
#' }
#' 
#'
#' @export
fieldCount<-function(mosaic, 
                     fieldShape=NULL, 
                     watershed=TRUE,
                     plot=FALSE,
                     pch ="+", 
                     col = 'red') {
  # Check if the input is a valid terra raster object
  if ((!isTRUE(terra::is.bool(mosaic))) | !length(dim(mosaic)) >= 2) {
stop("fieldCount requires a 2-dimensional terra raster object (mask layer)")
}
  
  # Define variables
  all_attri <- NULL
  rast_obj <- NULL
  
  if(!is.null(watershed) && !is.null(fieldShape)){
    binay<-terra::ifel(mosaic,0,1)
    img<-terra::as.array(t(as.matrix(binay, wide=TRUE)))
    img[is.na(img)] <- TRUE
    dis<-EBImage::distmap(img)
    seg<-EBImage::watershed(dis,watershed)
    ebi<-terra::as.array(seg)
    rast_obj <- terra::rast(t(as.matrix(rast(ebi), wide=TRUE)))
    rast_obj[rast_obj== 0] <- NA
    crs(rast_obj)<-crs(mosaic)
    ext(rast_obj)<-ext(mosaic)
    # Convert to polygons
    poly <- as.polygons(rast_obj)
    # Plot and add text labels
    if(plot){
      par(mfrow=c(1,2))
      terra::plot(rast_obj)
      terra::plot(fieldShape$geometry,col='#00008800',alpha=0,add=TRUE)
      suppressWarnings(terra::plot(st_geometry(st_centroid(st_as_sf(poly))), 
                            pch = pch, col = col))
      terra::plot(fieldShape$geometry,col='#00008800',alpha=0,add=TRUE)
      par(mfrow=c(1,1))
    }
    perimeter<-perim(poly)
    area<-expanse(poly)
    width<-width(poly)
    attri<-st_as_sf(poly)
    suppressWarnings(xy<-terra::crds(vect(st_centroid(attri))))    
    attributes<-cbind(attri[,-1],area,perimeter,width,xy)
    att<-cbind(ID = 1:nrow(attri[,-1]),attri[,-1],area,perimeter,width,xy)
    c<-st_join(fieldShape, st_as_sf(attributes))
    all<- c%>% group_by(ID) %>% 
      summarize(area =round(sum(area),3),
                perimeter=round(sum(perimeter),3),count=n(),mean_width=round(mean(width),3))
    all_attri<-list(plot_level=all,
                    object_level=att)
  }else if(is.null(watershed) || is.null(fieldShape)){
    logi<-terra::ifel(mosaic,NA,1)
    rast_obj<- patches(logi, directions = 4)
    poly <- as.polygons(rast_obj)
    poly$ID <- seq.int(nrow(poly))
    if(plot){
      par(mfrow=c(1,2))
      terra::plot(rast_obj)
      terra::plot(poly)
    par(mfrow=c(1,1))}
    perimeter<-perim(poly)
    area<-expanse(poly)
    width<-width(poly)
    attri<-st_as_sf(poly)
    attributes<-cbind(attri[,-1],area,perimeter,width)
    all_attri<-st_as_sf(attributes)[-1,]
  }else if(!is.null(watershed) && is.null(fieldShape)){
    binay<-terra::ifel(mosaic,0,1)
    img<-terra::as.array(t(as.matrix(binay,wide=TRUE)))
    img[is.na(img)] <- TRUE
    dis<-EBImage::distmap(img)
    seg<-EBImage::watershed(dis,watershed)
    ebi<-terra::as.array(seg)
    rast_obj <- terra::rast(t(as.matrix(rast(ebi), wide=TRUE)))
    rast_obj[rast_obj== 0] <- NA
    crs(rast_obj)<-crs(mosaic)
    ext(rast_obj)<-ext(mosaic)
    # Convert to polygons
    poly <- as.polygons(rast_obj)
    # Plot and add text labels
    if(plot){
      par(mfrow=c(1,2))
      terra::plot(rast_obj)
      suppressWarnings(terra::plot(st_geometry(st_centroid(st_as_sf(poly))), 
                            pch = pch,cex=0.05,col = col))
    par(mfrow=c(1,1))}
    perimeter<-perim(poly)
    area<-expanse(poly)
    width<-width(poly)
    attri<-st_as_sf(poly)
    attributes<-cbind(attri[,-1],area,perimeter,width)
    all_atti<-st_as_sf(attributes)
  } 
  
  return(all_attri)
}
