
## [FIELDimageR](https://github.com/filipematias23/FIELDimageR): A tool to analyze orthomosaic images from agricultural field trials in [R](https://www.r-project.org).

> This package is a compilation of functions to analyze orthomosaic images from research fields. To prepare the image it first allows to crop the image, remove soil and weeds and rotate the image. The package also builds a plot shapefile in order to extract information for each plot to evaluate different wavelengths, vegetation indices, stand count, canopy percentage, and plant height.

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/FIELDimageR.jpg" width="70%" height="70%">
</p>

<div id="menu" />

---------------------------------------------
## Resources
  
   * [Installation](#Instal)
   * [1. Required packages](#P1)
   * [2. Selecting the targeted field](#P2)
   * [3. Rotating the image](#P3)
   * [4. Removing soil using vegetation indices](#P4)
   * [5. Building the plot shape file](#P5)
   * [6. Building vegetation indices](#P6)
   * [7. Counting the number of plants](#P7)
   * [8. Evaluating the canopy percentage](#P8)
   * [9. Extracting data from field images](#P9)
   * [10. Estimating plant height](#P10)
   * [11. Removing objects (plot, cloud, weed, etc.)](#P11)
   * [12. Resolution and computing time](#P12)
   * [13. Crop growth cycle](#P13)
   * [14. Multispectral images](#P14)
   * [15. Making plots](#P15)
   * [16. Saving output files](#P16)
   * [Contact](#P17)

<div id="Instal" />

---------------------------------------------
### Installation

> In order to install R/FIELDimageR from GitHub [GitHub repository](https://github.com/filipematias23/FIELDimageR), first you need to install the [devtools](https://github.com/hadley/devtools) package in R.

```r
install.packages("devtools")

```
<br />

> Now install R/FIELDimageR using the `install_github` function from [devtools](https://github.com/hadley/devtools) package.

```r
library(devtools)
install_github("filipematias23/FIELDimageR")

```
[Menu](#menu)

<div id="P1" />

---------------------------------------------
### Using R/FIELDimageR

<br />

#### 1. Required packages

> * **[FIELDimageR](https://github.com/filipematias23/FIELDimageR)** 
> * **[sp](https://CRAN.R-project.org/package=sp)** 
> * **[raster](https://CRAN.R-project.org/package=raster)** 
> * **[rgdal](https://CRAN.R-project.org/package=rgdal)** 

```r
install.packages("sp")
install.packages("raster")
install.packages("rgdal")

library(FIELDimageR)
library(raster)

```
[Menu](#menu)

<div id="P2" />

---------------------------------------------
#### 2. Selecting the targeted field from the original image

> It is necessary to first reduce the image/mosaic size around the field boundaries for faster image analysis. Function to use: **`fieldCrop`**. The following example uses an image available to download here: [EX1_RGB.tif](https://drive.google.com/open?id=1S9MyX12De94swjtDuEXMZKhIIHbXkXKt). 

```r
EX1<-stack("EX1_RGB.tif")
plotRGB(EX1, r = 1, g = 2, b = 3)

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F1.jpeg">
</p>

<br />

```r
EX1.Crop <- fieldCrop(mosaic = EX1) # For heavy images (large, high resolution, etc.) please use: fast.plot=T

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F2.jpeg">
</p>

[Menu](#menu)

<div id="P3" />

---------------------------------------------
#### 3. Rotating the image

> To build the plot shape file first we need to make sure that the image base line (dashed in red) has a correct straight position (vertical or horizontal). If not, it is necessary to find the right-angle *theta* to rotate the field, **`fieldRotate`** allows you to click directly on the image and select two points on where you want to base your field and return the theta value to finally rotate the image. 

```r
EX1.Rotated<-fieldRotate(mosaic = EX1.Crop, clockwise = F)
EX1.Rotated<-fieldRotate(mosaic = EX1.Crop,theta = 2.3)

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F4.jpeg">
</p>

[Menu](#menu)

<div id="P4" />

---------------------------------------------
#### 4. Removing soil using vegetation indices 

> The presence of soil can introduce bias in the data extracted from the image. Therefore, removing soil from the image is one of the most important steps for image analysis in agricultural science. Function to use: **`fieldMask`** 

```r
EX1.RemSoil<- fieldMask(mosaic = EX1.Rotated, Red = 1, Green = 2, Blue = 3, index = "HUE")

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F3.jpeg">
</p>

[Menu](#menu)

<div id="P5" />

---------------------------------------------
#### 5. Building the plot shape file

> Once the field has reached a correct straight position, the plot shape file can be drawn by selecting at least four points at the corners of the experiment. The number of columns and rows must be informed. At this point the experimental borders can be eliminated, in the example bellow the borders were removed in all the sides. Function to use: **`fieldShape`** 

```r
EX1.Shape<-fieldShape(mosaic = EX1.RemSoil,ncols = 14, nrows = 9)

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F5.jpeg">
</p>

<br />

> **Attention:** The plots are identified in ascending order from left to right and top to bottom being evenly spaced and distributed inside the selected area independent of alleys. 

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F24.jpeg">
</p>

<br />

> To identify the plots the function **`fieldMap`** can be used to include an specific plot *ID* from an external table file. The column **PlotName** in the output will be the new ID. You can dowload an example of an ID table here: [DataTable.csv](https://drive.google.com/open?id=18YE4dlSY1Czk2nKeHgwd9xBX8Yu6RCl7).

```r
### Field map ID identification. 'fieldPlot' argument comes from the plot ID (number or name).

DataTable<-read.csv("DataTable.csv",header = T)  
fieldMap<-fieldMap(fieldPlot=DataTable$Plot, fieldRange=DataTable$Range, fieldRow=DataTable$Row, decreasing=T)
fieldMap

EX1.Shape<-fieldShape(mosaic = EX1.RemSoil, ncols = 14, nrows = 9, fieldMap = fieldMap)
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F10.jpeg">
</p>

<br />


```r
### Joing all information in one "fieldShape" file:

EX1.Shape<-fieldShape(mosaic = EX1.RemSoil, ncols = 14, nrows = 9, fieldMap = fieldMap, 
                      fieldData = DataTable, ID = "Plot")
EX1.Shape$fieldShape@data                      
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F11.jpeg">
</p>

<br />

```r
### Different plot dimensions using "fieldShape":

# ncols = 14 and nrows = 9
EX1.Shape.1Line<-fieldShape(mosaic = EX1.RemSoil, ncols = 14, nrows = 9)

# ncols = 7 and nrows = 9
EX1.Shape.2lines<-fieldShape(mosaic = EX1.RemSoil, ncols = 7, nrows = 9)

# ncols = 7 and nrows = 3
EX1.Shape.6lines<-fieldShape(mosaic = EX1.RemSoil, ncols = 7, nrows = 3)                     
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F26.jpeg">
</p>

[Menu](#menu)

<div id="P6" />

---------------------------------------------
#### 6. Building vegetation indices 

> A general number of indices are implemented in *FIELDimageR* using the function **`indices`**. Also, yo can build your own index using the parameter `myIndex`. 

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F6ind.jpeg">
</p>
<br />

```r
# Calculating myIndex = "(Red-Blue)/Green" (not avaliable at 'FIELDimageR')

EX1.Indices<- indices(mosaic = EX1.RemSoil$newMosaic, Red = 1, Green = 2, Blue = 3, 
                          index = c("NGRDI","BGI"), myIndex = c("(Red-Blue)/Green"))
                          
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F7.jpeg">
</p>

<br />

> *Sugestion:* This function could also be used to build an index to remove soil or weeds. First it is necessary to identify the threshold to differentiate soil from the plant material. At the example below (B), all values above 0.7 were considered as soil and further removed using **`fieldMask`** (C & D).

```r
plot(EX1.Indices$BGI)

EX1.BGI<- fieldMask(mosaic = EX1.Rotated, Red = 1, Green = 2, Blue = 3, 
                   index = "BGI", cropValue = 0.7, cropAbove = T) #Check if: cropValue=0.8 or cropValue=0.6 works better.
                                            
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F23.jpeg">
</p>

[Menu](#menu)

<div id="P7" />

---------------------------------------------
#### 7. Counting the number of plants

> *FIELDimageR* can be used to evaluate stand count during early stages. A good weed control practice should be performed to avoid misidentification inside the plot.  The *mask* output from **`fieldMask`** and the *fieldshape* output from **`fieldShape`** must be used. Function to use: **`standCount`**. The parameter *n.core* is used to accelerate the counting (parallel).

```r
EX1.SC<-standCount(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape, cex=0.4, col="blue")
EX1.SC$standCount

### Parallel (n.core = 3)
EX1.SC<-standCount(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape, n.core = 3, cex=0.4, col="blue")
EX1.SC$standCount
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F9.jpeg">
</p>

<br />

> To refine stand count, we can further eliminate weeds (small plants) or outlying branches from the output using the parameter *min Size*. The following example uses an image available to download here:[EX_StandCount.tif](https://drive.google.com/open?id=1PzWcIsYQMxgEozR5HHUhT0RKcstMOfSk)

```r
# Uploading file
EX.SC<-stack("EX_StandCount.tif")
plotRGB(EX.SC, r = 1, g = 2, b = 3)

# Removing the soil
EX.SC.RemSoil<- fieldMask(mosaic = EX.SC, Red = 1, Green = 2, Blue = 3, index = "HUE")

# Building the plot shapefile (ncols = 1 and nrows = 7)
EX.SC.Shape<-fieldShape(mosaic = EX.SC.RemSoil,ncols = 1, nrows = 7)
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F20.jpeg">
</p>

<br />

```r
### When all shapes are counted: minSize = 0.00

EX1.SC<-standCount(mosaic = EX.SC.RemSoil$mask, 
                   fieldShape = EX.SC.Shape$fieldShape,
                   minSize = 0.00)
                   
EX1.SC$plantSel[[4]] # Identifies 14 points, but point 6 and 9 are small artifacts
EX1.SC$plantReject[[4]] # No shape rejected because minSize = 0.00
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F21.jpeg">
</p>

<br />

```r
### When all shapes with size greater than 0.04% of plot area are counted: minSize = 0.04

EX1.SC<-standCount(mosaic = EX.SC.RemSoil$mask, 
                   fieldShape = EX.SC.Shape$fieldShape,
                   minSize = 0.04)

EX1.SC$plantSel[[4]] # Identifies 12 points
EX1.SC$plantReject[[4]] # Shows 2 artifacts that were rejected (6 and 9 from previous example)
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F22.jpeg">
</p>

[Menu](#menu)

<div id="P8" />

---------------------------------------------
#### 8. Evaluating the canopy percentage

> *FIELDimageR* can also be used to evaluate the canopy percentage per plot.  The *mask* output from **`fieldMask`** and the *fieldshape* output from **`fieldShape`** must be used. Function to use: **`canopy`**. The parameter *n.core* is used to accelerate the canopy extraction (parallel).

```r
EX1.Canopy<-canopy(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape)
EX1.Canopy$canopyPorcent

### Parallel (n.core = 3)
EX1.Canopy<-canopy(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape, n.core = 3)
EX1.Canopy$canopyPorcent
```

[Menu](#menu)

<div id="P9" />

---------------------------------------------
#### 9. Extracting data from field images 

> The function *extract* from **[raster](https://CRAN.R-project.org/package=raster)** is adapted for agricultural field experiments through function **`getInfo`**. The parameter *n.core* is used to accelerate the plot extraction (parallel).

```r
EX1.Info<- getInfo(mosaic = EX1.Indices,fieldShape = EX1.Shape$fieldShape)
EX1.Info$fieldShape@data

### Parallel (n.core = 3)
EX1.Info<- getInfo(mosaic = EX1.Indices,fieldShape = EX1.Shape$fieldShape, n.core = 3)
EX1.Info$fieldShape@data

```

[Menu](#menu)

<div id="P10" />

---------------------------------------------
#### 10. Estimating plant height

> The plant height can be estimated by calculating the Canopy Height Model (CHM). This model uses the difference between the Digital Surface Model (DSM) from the soil base (before there is any sproute, [Download EX_DSM0.tif](https://drive.google.com/open?id=1lrq-5T6x_GrbkCtpDSDiX1ldvSwEBFX-)) and the DSM file from the vegetative growth (once plants are grown, [Download EX_DSM1.tif](https://drive.google.com/open?id=1q_H4Ef1f1yQJOPtkVMJfcb2SvHcxJ3ya)). To calculate the plant height, first we used a previously generated *mask* from step 4 to remove the soil, and the output from *fieldshape* in step 5 to assign data to each plot. The user can extract information using the basic R functions mean, max, min, and quantile as a parameter in function **`getInfo`**. 

```r
# Uploading files from soil base (EX_DSM0.tif) and vegetative growth (EX_DSM1.tif):
DSM0 <- stack("EX_DSM0.tif")
DSM1 <- stack("EX_DSM1.tif")

# Cropping the image using the previous shape from step 2:
DSM0.C <- fieldCrop(mosaic = DSM0,fieldShape = EX1.Crop)
DSM1.C <- fieldCrop(mosaic = DSM1,fieldShape = EX1.Crop)

# Canopy Height Model (CHM):
DSM0.R <- resample(DSM0.C, DSM1.C)
CHM <- DSM1.C-DSM0.R

# Rotating the image using the same theta from step 3:
CHM.R<-fieldRotate(CHM, theta = 2.3)

# Removing the soil using mask from step 4:
CHM.S <- fieldMask(CHM.R, mask = EX1.RemSoil$mask)

# Extracting the estimate plant height average (EPH):
EPH <- getInfo(CHM.S$newMosaic, fieldShape = EX1.Shape$fieldShape, fun = "mean")
EPH$plotValue

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F13.jpeg">
</p>

[Menu](#menu)

<div id="P11" />

---------------------------------------------
#### 11. Removing objects (plot, cloud, weed, etc.) 

> The function **`fieldCrop`** can be used to remove objects from the field image. For instance, the parameter *remove=TRUE* and *nPoint* should be used to select the object boundaries to be removed. [Download EX_RemObj.tif](https://drive.google.com/open?id=1wfxSQANRrPOvJWwNZ6UU0UjXwzKfkKH0)).

```r
# Uploading file (EX_RemObj.tif)
EX.RemObj <- stack("EX_RemObj.tif")

# Selecting the object boundaries to be removed (nPoint = 10)
EX.RemObj.Crop <- fieldCrop(mosaic = EX.RemObj, remove = T, nPoint = 10) # Selecting the plant in plot 13

# Removing the soil
EX.RemObj.RemSoil<- fieldMask(mosaic = EX.RemObj.Crop,index = "HUE")

# Building the plot shapefile (ncols = 8 and nrows = 4)
EX.RemObj.Shape<-fieldShape(mosaic = EX.RemObj.RemSoil,ncols = 8, nrows = 4)

# Building indice (NGRDI)
EX.RemObj.Indices<- indices(mosaic = EX.RemObj.RemSoil$newMosaic,index = c("NGRDI"))

# Extracting data (NGRDI)
EX.RemObj.Info<- getInfo(mosaic = EX.RemObj.Indices$NGRDI,
                      fieldShape = EX.RemObj.Shape$fieldShape,
                      n.core = 3)
                      
# Comparing plots values (the plant in plot 13 was removed and its value must be lower than plot 12 and 14)                      
EX.RemObj.Info$plotValue[c(12,13,14),]

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F25.jpg">
</p>

[Menu](#menu)

<div id="P12" />

---------------------------------------------
#### 12. Resolution and computing time

> The influence of image resolution was evaluated at different steps of the FIELDimageR pipeline. For this propose, the resolution of image *EX1_RGB_HighResolution.tif* [Download](https://drive.google.com/open?id=1elZe2jfq4bQSZM8cFAS4q7fRrnXbSBgH) was reduced using the function **raster::aggregate** in order to simulate different flown altitudes Above Ground Surface (AGS). The parameter *fact* was used to modify the original image resolution (0.4x0.4 cm with 15m AGS) to: first, **fact=2** to reduce the original image to 0.8x0.8 cm (simulating 30m AGS), and **fact=4** to reduce the original image to 1.6x1.6 (simulating 60m AGS). The steps (*i*) cropping image, (*ii*) removing soil, (*iii*) rotating image, (*iv*) building vegetation index (BGI), and (*v*) getting information were evaluated using the function **system.time** output *elapsed* (R base).

```r
### Image and resolution decrease 

RES_1<-stack("EX1_RGB_HighResolution.tif")
RES_2<-aggregate(RES_1, fact=2)
RES_4<-aggregate(RES_1, fact=4)

res(RES_1)
res(RES_2)
res(RES_4)

par(mfrow=c(1,3))
plotRGB(RES_1)
plotRGB(RES_2)
plotRGB(RES_4)

### Crooping 

system.time({RES_1_C <- fieldCrop(mosaic = RES_1,fieldShape = EX1.Crop, plot = T)})
system.time({RES_2_C <- fieldCrop(mosaic = RES_2,fieldShape = EX1.Crop, plot = T)})
system.time({RES_4_C <- fieldCrop(mosaic = RES_4,fieldShape = EX1.Crop, plot = T)})

### Rotating 
  
system.time({RES_1_R <- fieldRotate(RES_1_C,theta = 2.3, plot = T)}) 
system.time({RES_2_R <- fieldRotate(RES_2_C,theta = 2.3, plot = T)})
system.time({RES_4_R <- fieldRotate(RES_4_C,theta = 2.3, plot = T)})
  
### Removing Soil 

system.time({RES_1_S <- fieldMask(RES_1_R,index="HUE")})
system.time({RES_2_S <- fieldMask(RES_2_R,index="HUE")})
system.time({RES_4_S <- fieldMask(RES_4_R,index="HUE")})

### Indices
  
system.time({RES_1_I <- indices(RES_1_S$newMosaic,index=c("BGI"))})
system.time({RES_2_I <- indices(RES_2_S$newMosaic,index=c("BGI"))})
system.time({RES_4_I <- indices(RES_4_S$newMosaic,index=c("BGI"))})
  
### Get Information (1 Band)
  
system.time({RES_1_Info <- getInfo(RES_1_I$BGI,fieldShape = EX1.Shape$fieldShape,n.core = 3)})
system.time({RES_2_Info <- getInfo(RES_2_I$BGI,fieldShape = EX1.Shape$fieldShape,n.core = 3)})
system.time({RES_4_Info <- getInfo(RES_4_I$BGI,fieldShape = EX1.Shape$fieldShape,n.core = 3)})
  
### Get Information (3 Bands)
  
system.time({RES_1_Info2 <- getInfo(RES_1_I[[c(1,2,3)]],fieldShape = EX1.Shape$fieldShape,n.core = 3)})
system.time({RES_2_Info2 <- getInfo(RES_2_I[[c(1,2,3)]],fieldShape = EX1.Shape$fieldShape,n.core = 3)})
system.time({RES_4_Info2 <- getInfo(RES_4_I[[c(1,2,3)]],fieldShape = EX1.Shape$fieldShape,n.core = 3)})

### Correlation

DataBGI <- data.frame(R1=RES_1_Info$plotValue$BGI,
                    R2=RES_2_Info$plotValue$BGI,
                    R4=RES_4_Info$plotValue$BGI)
DataBlue <- data.frame(R1=RES_1_Info2$plotValue$Blue,
                       R2=RES_2_Info2$plotValue$Blue,
                       R4=RES_4_Info2$plotValue$Blue)
DataGreen <- data.frame(R1=RES_1_Info2$plotValue$Green,
                       R2=RES_2_Info2$plotValue$Green,
                       R4=RES_4_Info2$plotValue$Green)
DataRed <- data.frame(R1=RES_1_Info2$plotValue$Red,
                       R2=RES_2_Info2$plotValue$Red,
                       R4=RES_4_Info2$plotValue$Red)
cor(DataBGI)
cor(DataBlue)
cor(DataGreen)
cor(DataRed)

```
> The time to run one function using the image with pixel size of 0.4x0.4 cm can be 10 (**`getInfo`**) to 70 times (**`indices`**) slower than the image with pixel size of 1.6x1.6 cm (Table 1). The computing time to extract BGI index (one layer) with 0.4x0.4 cm was ~23 min whereas  only ~7 min with the 0.8x0.8 cm image, and ~2 min using the 1.6x1.6 cm image. the time to extract the RGB information (three layers) was ~2.3 min for the 1.6x1.6 cm image and ~66 min for the 0.4x0.4 cm image. It is important to highlight that the resolution did not affect the plots mean, it has a correlation >99% between 0.4x0.4 cm and 1.6x1.6 (Table 2). High resolution images showed to require higher computational performance, memory, and storage space. We experienced that during the image collection in the field a low altitudes flight needs more batteries and a much greater number of pictures, and consequently longer preprocessing images steps to build ortho-mosaics.

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F14.jpeg">
</p>

[Menu](#menu)

<div id="P13" />

---------------------------------------------
#### 13. Crop growth cycle

> The same rotation theta from step 3, mask from step 4, and plot shape file from step 5, can be used to evaluate mosaics from other stages in the crop growth cycle. Here you can download specific images from flowering and senecense stages in potatoes.  ([**Flowering: EX2_RGB.tif**](https://drive.google.com/open?id=1B1HrIYUVqSpKdDN8E8VudpI8jT8MYbWY) and [**Senescence: EX3_RGB.tif**](https://drive.google.com/open?id=15GpLy669mICpkorbUk1M9vqfSUMHbdc5))

```r
# Uploading Flowering (EX2_RGB.tif) and Senescence (EX3_RGB.tif) files:
EX2 <- stack("EX2_RGB.tif")
EX3 <- stack("EX3_RGB.tif")

# Cropping the image using the previous shape from step 2:

EX2.Crop <- fieldCrop(mosaic = EX2,fieldShape = EX1.Crop, plot = T)
EX3.Crop <- fieldCrop(mosaic = EX3,fieldShape = EX1.Crop, plot = T)

# Rotating the image using the same theta from step 3:

EX2.Rotated<-fieldRotate(EX2.Crop,theta = 2.3, plot = T)
EX3.Rotated<-fieldRotate(EX3.Crop,theta = 2.3, plot = T)

# Removing the soil using index and mask from step 4:

EX2.RemSoil<-fieldMask(EX2.Rotated,index="HUE",cropValue=0,cropAbove=T,plot=T)
EX3.RS<-fieldMask(EX3.Rotated,index="HUE",cropValue=0,cropAbove=T,plot=T) # Removing soil at senescence stage
EX3.RemSoil<-fieldMask(EX3.RS$newMosaic,mask = EX2.RemSoil$mask ,cropValue=0,cropAbove=T,plot=T) # Removing weeds from senescence stage with flowering mask 

# Building indices

EX2.Indices <- indices(EX2.RemSoil$newMosaic,Red=1,Green=2,Blue=3,
                 index = c("NGRDI","BGI"), myIndex = c("(Red-Blue)/Green"))
EX3.Indices <- indices(EX3.RemSoil$newMosaic,Red=1,Green=2,Blue=3,
                 index = c("NGRDI","BGI"), myIndex = c("(Red-Blue)/Green"))

# Extracting data using the same fieldShape file from step 5:

EX2.Info<- getInfo(mosaic = EX2.Indices$myIndex,fieldShape = EX1.Shape$fieldShape,n.core = 3)
EX3.Info<- getInfo(mosaic = EX3.Indices$myIndex,fieldShape = EX1.Shape$fieldShape,n.core = 3)

Data.Cycle<-data.frame(EX1=EX1.Info$plotValue$myIndex,
      EX2=EX2.Info$plotValue$myIndex,
      EX3=EX3.Info$plotValue$myIndex)

Data.Cycle
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F15.jpeg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F16.jpeg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F17.jpeg">
</p>

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F18.jpeg">
</p>

[Menu](#menu)

<div id="P14" />

---------------------------------------------
#### 14. Multispectral images

> **`FIELDimageR`** can be used to analyze multispectral images. The same rotation theta, mask, and plot shape file used to analyze RGB mosaic above can be used to analyze multispectral mosaic from the same field. You can dowload an example here: [**EX1_5Band.tif**](https://drive.google.com/open?id=1vYb3l41yHgzBiscXm_va8HInQsJR1d5Y) 

<br />

> **Attention:** HYPERSPECTRAL images were not tested in *`FIELDimageR`*

<br />

```r
# Uploading multispectral mosaic:
EX1.5b <- stack("EX1_5Band.tif")

# Cropping the image using the previous shape from step 2:

EX1.5b.Crop <- fieldCrop(mosaic = EX1.5b,fieldShape = EX1.Crop, plot = T)

# Rotating the image using the same theta from step 3:

EX1.5b.Rotated<-fieldRotate(EX1.5b.Crop,theta = 2.3, plot = T)

# Removing the soil using index and mask from step 4:

EX1.5b.RemSoil<-fieldMask(EX1.5b.Rotated,Red=1,Green=2,Blue=3,index="HUE",cropValue=0,cropAbove=T,plot=T)

# Building indices (NDVI and NDRE)

EX1.5b.Indices <- indices(EX1.5b.RemSoil$newMosaic,Red=1,Green=2,Blue=3,RedEdge=4,NIR=5,
                 index = c("NDVI","NDRE"))

# Extracting data using the same fieldShape file from step 5:

EX1.5b.Info<- getInfo(mosaic = EX1.5b.Indices$NDVI,fieldShape = EX1.Shape$fieldShape,n.core = 3)

```
[Menu](#menu)

<div id="P15" />

---------------------------------------------
#### 15. Making plots

> Graphic visualization of trait values for each plot using the **fieldShape file** and the **Mosaic** of your preference. Function to use: **`fieldPlot`**.

```r
### Interpolating colors: c("white","black")

fieldPlot(fieldShape=EX1.Info$fieldShape,fieldAttribute="Yield", mosaic=EX1.Indices, color=c("white","black"), alpha = 0.5)

### Interpolating colors: c("red","blue")

fieldPlot(fieldShape=EX1.Info$fieldShape,fieldAttribute="myIndex", mosaic=EX1.Indices, color=c("red","blue"), alpha = 0.5)

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F12.jpeg">
</p>

[Menu](#menu)

<div id="P16" />

---------------------------------------------
#### 16. Saving output files

```r
### Images (single and multi layers)
writeRaster(EX1.Indices, filename="EX1.Indices.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
# EX1.Indices.2 <- stack("EX1.Indices.tif") # Reading the saved image.

### FieldShape file
library(rgdal)
writeOGR(EX1.Info$fieldShape, ".", "EX1.fieldShape", driver="ESRI Shapefile")
# EX1.fieldShape.2 <- readOGR("EX1.fieldShape.shp") # Reading the saved shapefile.

### CSV file (table)
write.csv(EX1.Info$fieldShape@data,file = "EX1.Info.csv",col.names = T,row.names = F)
# Data.EX1.Info<-read.csv("EX1.Info.csv",header = T,check.names = F) # Reading the saved data table.

```
[Menu](#menu)

<div id="P17" />

---------------------------------------------
### YouTube Tutorial

<br />

> FIELDimageR: A tool to analyze orthomosaic images from agricultural field trials in R (Basic Pipeline)
<p align="center">
<a href="https://youtu.be/ZXyaePAv9r8"><img src="https://github.com/filipematias23/images/blob/master/readme/YouTube.jpeg" width=400 height=300 title="Watch the video"></a>
</p>

> FIELDimageR: Counting the number of plants (StandCount)
<p align="center">
<a href="https://youtu.be/v0gAq302Ueg"><img src="https://github.com/filipematias23/images/blob/master/readme/YouTubeSC.jpeg" width=400 height=300 title="Watch the video"></a>
</p>

<br />

### Google Groups Forum

> This discussion group provides an online source of information about the FIELDimageR package.  

Report a bug and ask a question at https://groups.google.com/forum/#!forum/fieldimager

<br />

### Licenses

> The R/FIELDimageR package as a whole is distributed under [GPL-2 (GNU General Public License version 2)](https://www.gnu.org/licenses/gpl-2.0.en.html).

<br />

### Author

> * [Filipe Inacio Matias](https://github.com/filipematias23)

<br />

### Acknowledgments

> * [University of Wisconsin - Madison](https://horticulture.wisc.edu)
> * [UW Potato Breeding and Genetics Laboratory](https://potatobreeding.cals.wisc.edu)
> * [Dr Jeffrey Endelman, PhD Student Maria Caraza-Harter, and MS Student 
Lin Song](https://potatobreeding.cals.wisc.edu/people/)

<br />

[Menu](#menu)

<br />

