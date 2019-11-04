fieldMap<-function(fieldPlot, fieldRange, fieldRow, decreasing=F){
  if(length(fieldPlot)!=length(fieldRange)|length(fieldPlot)!=length(fieldRow)|length(fieldRow)!=length(fieldRange)){
    stop("Plot, Range and Row vectors must have the same length.")
  }
  map<-NULL
  for(i in 1:length(fieldRange)){
    r1<-as.character(fieldPlot[fieldRange==i][order(as.numeric(fieldRow[fieldRange==i]),decreasing = decreasing)])
    map<-rbind(map,r1)
  }
  colnames(map)<-NULL
  rownames(map)<-NULL
  return(map)}
