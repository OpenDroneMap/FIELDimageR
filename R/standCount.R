standCount <-function(mosaic, fieldShape, value=0, minSize=0.01, n.core=NULL, pch=16, cex=0.7, col="red"){
  if(projection(fieldShape)!=projection(mosaic)){stop("fieldShape and mosaic must have the same projection CRS, strongly suggested to use fieldRotate() for both files.")}
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  if(num.band>1){stop("Only mask with values of 1 and 0 can be processed, use the mask output from fieldMask()")}
  if(!value%in%c(1,0)){stop("Values in the mask must be 1 or 0 to represent the plants, use the mask output from fieldMask()")}
  if(!all(c(raster::minValue(mosaic),raster::maxValue(mosaic))%in%c(1,0))){stop("Values in the mask must be 1 or 0 to represent the plants, use the mask output from fieldMask()")}
  mosaic <- crop(x = mosaic, y = fieldShape)
  print("Identifying plants... ")
  par(mfrow=c(1,1))
  raster::plot(mosaic, col=grey(1:100/100), axes=FALSE, box=FALSE, legend=FALSE)
  sp::plot(fieldShape, add=T)
  names(mosaic)<-"mask"
  mask <- raster::as.matrix(mosaic$mask) == value
  dd <- distmap(mask)
  mosaic$watershed <- watershed(dd)
  if(is.null(n.core)){extM <- extract(x = mosaic$watershed, y = fieldShape)}
  if (!is.null(n.core)){
    cl <- makeCluster(n.core, output = "")
    registerDoParallel(cl)
    extM <- foreach(i = 1:length(fieldShape), .packages = c("raster")) %dopar% {
      single <- fieldShape[i, ]
      CropPlot <- crop(x = mosaic$watershed, y = single)
      extract(x = CropPlot, y = single)
    }
    names(extM) <- 1:length(fieldShape)
  }
  plants<-lapply(extM, function(x){table(x)})
  cent <- lapply(plants, function(x){as.numeric(names(x))[-1]})
  plantsPosition<- lapply(cent, function(x){
    if(length(x)==0){return(NULL)}
    pos<-NULL
    for(i in 1:length(x)){pos<-rbind(pos,colMeans(xyFromCell(mosaic$watershed, which(mosaic$watershed[]==x[i]))))}
    if(abs(max(pos[,1])-min(pos[,1]))>=abs(max(pos[,2])-min(pos[,2]))){ord<-order(pos[,1])}
    if(abs(max(pos[,1])-min(pos[,1]))<abs(max(pos[,2])-min(pos[,2]))){ord<-order(pos[,2])}
    pos<-pos[ord,]
    return(list(seqName=ord,Position=pos))})
  plantSel<-list()
  plantReject<-list()
  for(j in 1:length(cent)){
    x1<-plants[[j]]
    y<-plantsPosition[[j]]
    x<-NULL
    PS<-NULL
    PR<-NULL
    if(!is.null(y)){
    for (i in 2:length(x1)) {x<-c(x,round(100*(x1[i]/sum(x1)),3))}
    x<-x[y$seqName]
    
    if(dim(as.matrix(y$Position))[2]==1){
    PS <- data.frame(plantCanopy = x[x >= minSize], x = y$Position[1][x >= minSize], y = y$Position[2][x >= minSize])
    PR <- data.frame(plantCanopy = x[x < minSize], x = y$Position[1][x < minSize], y = y$Position[2][x < minSize])
  }
  if(dim(as.matrix(y$Position))[2]!=1){
  PS <- data.frame(plantCanopy = x[x >= minSize], 
                   x = y$Position[x >= minSize, 1], 
                   y = y$Position[x >= minSize, 2])
  PR <- data.frame(plantCanopy = x[x < minSize], 
                   x = y$Position[x < minSize, 1], 
                   y = y$Position[x < minSize, 2])
  }}
    rownames(PS)<-NULL
    rownames(PR)<-NULL
    plantSel[[j]]<-PS
    plantReject[[j]]<-PR
  }
  stand <- unlist(lapply(plantSel, function(x){length(x$plantCanopy)}))
  fieldShape@data$standCount <- stand
  print(paste("Number of plants: ", sum(stand), sep = ""))
  graphics::points(do.call(rbind,plantSel)[,c(2,3)], pch=pch, cex=cex, col=col)
  sp::plot(fieldShape, add=T)
  Out <- list(standCount=stand, fieldShape=fieldShape, mosaic=mosaic$watershed, plantSel=plantSel, plantReject=plantReject)
  return(Out)
}

