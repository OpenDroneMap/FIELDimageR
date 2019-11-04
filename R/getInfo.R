getInfo<-function(mosaic,fieldShape,fun = "mean",plot=F,buffer=NULL,...){ # buffer is in the mosaic unit, usually in meters.
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  if(projection(fieldShape)!=projection(mosaic)){stop("fieldShape and mosaic must have the same projection CRS. Use fieldRotate() for both files.")}
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," bands available", sep = ""))
  CropPlot <- crop(x = mosaic, y = fieldShape)
  plotValue <- extract(x = CropPlot, y = fieldShape, fun = eval(parse(text =fun)), buffer=buffer, na.rm = T, df = T, ...)
  fieldShape@data<-cbind.data.frame(fieldShape@data,plotValue)
  Out<-list(fieldShape=fieldShape,plotValue=plotValue,cropPlot=CropPlot)
  if(plot){
    if(num.band>2){plotRGB(RGB.rescale(CropPlot, num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(CropPlot, axes=FALSE, box=FALSE)}
    sp::plot(fieldShape, add=T)
  }
  return(Out)}
