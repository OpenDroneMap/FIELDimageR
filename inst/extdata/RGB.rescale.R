
RGB.rescale<-function(mosaic, num.band){
  for(i in 1:num.band){
    mosaic[[i]]<-scales::rescale(values(mosaic[[i]]), to = c(0, 255))
  }
  return(mosaic)
}
