fieldMap<-function(fieldPlot, fieldColumn, fieldRow, decreasing=F){
  if(length(fieldPlot)!=length(fieldRow)|length(fieldPlot)!=length(fieldColumn)|length(fieldColumn)!=length(fieldRow)){
    stop("Plot, Column and Row vectors must have the same length.")
  }
  map<-NULL
  for(i in 1:length(fieldRow)){
    i1<-fieldRow[i]
    r1<-as.character(fieldPlot[fieldRow==i1][order(as.numeric(fieldColumn[fieldRow==i1]),decreasing = decreasing)])
    map<-rbind(map,r1)
  }
  colnames(map)<-NULL
  rownames(map)<-NULL
  return(as.matrix(map))}
