fieldIndex<-function(mosaic,Red=1,Green=2,Blue=3,RedEdge=NULL,NIR=NULL,index=c("HUE"),myIndex=NULL,plot=T){
  Ind<-read.csv(file=system.file("extdata", "Indices.txt", package = "FIELDimageR", mustWork = TRUE),header = T,sep = "\t")
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
