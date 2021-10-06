#' fieldAUC 
#' 
#' @title Area Under the Curve
#' 
#' @description Calculate the area under the curve given by vectors of xy-coordinates.
#' 
#' @param Data data table from \code{\link{fieldInfo}}.
#' @param trait one or more traits to be evaluated. 
#' @param keep.columns columns names to be maintained in the output dataset.
#' @param method the type of interpolation. Can be "trapezoid" (default), "step", "linear" or "spline". More information on ??DescTools::AUC. 
#' @param x.start value of x to start the AUC (default is 0 days after planting). 
#' @param y.start value of y to start the AUC (default is 0). 
#' @param frame format of output data. "long" is used for AUC values on the 1st column and traits ID on the2nd column. While "wide" is for objects with dimension n \times m where traits must be in columns and plots/sample in rows.
#' 
#' @importFrom DescTools AUC
#' 
#' @return A list with a data frame with values by plot and experimental field image with format stack.
#'
#' @export
fieldAUC<-function(data, 
                   trait, 
                   keep.columns=c("NAME","ROW","RANGE"),
                   method ="trapezoid",
                   x.start=0,
                   y.start=0,
                   frame = "long"){
  if(!c("DAP"%in%as.character(colnames(data)))){
    stop("Missing one column with days after planting named 'DAP'")
  }
  DataAUC<-NULL
  for(i in 1:length(trait)){
    trait1<-trait[i] 
    print(paste("Evaluating AUC for ",trait1,sep=""))
    Plot<-as.character(unique(Data$PlotName))
    DataAUC.1 <-NULL
    for(a1 in 1:length(Plot)){
      D1<-data[as.character(data$PlotName)==Plot[a1],]
      x1<-c(x.start,as.numeric(D1$DAP))
      y1<-c(y.start,as.numeric(D1[,trait1]))
      if(frame == c("long")){
        DataAUC <- rbind(DataAUC,
                         c(D1[1,c(keep.columns)],
                           TRAIT=trait1,
                           AUC=AUC(x = x1[!is.na(y1)], 
                                   y = y1[!is.na(y1)],
                                   method = method)))
      }
      if(frame=="wide"){
        if(i==1){
          DataAUC <- rbind(DataAUC,
                           c(D1[1,c(keep.columns)],AUC(x = x1[!is.na(y1)], 
                                                       y = y1[!is.na(y1)],
                                                       method = method)))
        }
        if(i!=1){
          DataAUC.1 <- c(DataAUC.1,AUC(x = x1[!is.na(y1)], 
                                       y = y1[!is.na(y1)],
                                       method = method))
        }
      }
    }
    if(frame=="wide"){
      DataAUC<-cbind(DataAUC,DataAUC.1)
      colnames(DataAUC)[dim(DataAUC)[2]]<-paste(trait1,"AUC",sep="_")}
  }
  DataAUC<-as.data.frame(as.matrix(DataAUC))
  return(DataAUC)}
