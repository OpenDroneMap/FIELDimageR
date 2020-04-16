
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
   * [5. Building the plot shapefile](#P5)
   * [6. Building vegetation indices](#P6)
   * [7. Counting the number of objects (e.g. plants, seeds, etc)](#P7)
   * [8. Evaluating the object area percentage (e.g. canopy)](#P8)
   * [9. Extracting data from field images](#P9)
   * [10. Estimating plant height](#P10)
   * [11. Removing objects (plot, cloud, weed, etc.)](#P11)
   * [12. Resolution and computing time](#P12)
   * [13. Crop growth cycle](#P13)
   * [14. Multispectral images](#P14)
   * [15. Building shapefile with polygons (field blocks, pest damage, soil differences, etc)](#P15)
   * [16. Making plots](#P16)
   * [17. Saving output files](#P17)
   * [Orthomosaic using the open source software OpenDroneMap](#P18)
   * [Parallel and loop to evaluate multiple images (e.g. images from roots, leaves, ears, seed, damaged area, etc.)](#P19)
   * [Quick tips (memory limits, splitting shapefile, using shapefile from other software, etc)](#P20)
   * [Contact](#P21)

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
install.packages("scales")

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
  <img src="https://github.com/filipematias23/images/blob/master/readme/F6ind2.jpeg">
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
EX1.Indices.BGI<- indices(mosaic = EX1.Rotated, index = c("BGI"))

hist(EX1.Indices.BGI$BGI) # Image segmentation start from 0.7 (soil and plants)

EX1.BGI<- fieldMask(mosaic = EX1.Rotated, Red = 1, Green = 2, Blue = 3, 
                   index = "BGI", cropValue = 0.7, cropAbove = T) 

#Check if: cropValue=0.8 or cropValue=0.6 works better.
                                            
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F23.jpeg">
</p>

[Menu](#menu)

<div id="P7" />

---------------------------------------------
#### 7. Counting the number of objects (e.g. plants, seeds, etc)

> *FIELDimageR* can be used to evaluate stand count during early stages. A good weed control practice should be performed to avoid misidentification inside the plot.  The *mask* output from **`fieldMask`** and the *fieldshape* output from **`fieldShape`** must be used. Function to use: **`fieldCount`**. The parameter *n.core* is used to accelerate the counting (parallel).

```r
EX1.SC<-fieldCount(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape, cex=0.4, col="blue")
EX1.SC$fieldCount

### Parallel (n.core = 3)
EX1.SC<-fieldCount(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape, n.core = 3, cex=0.4, col="blue")
EX1.SC$fieldCount
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

EX1.SC<-fieldCount(mosaic = EX.SC.RemSoil$mask, 
                   fieldShape = EX.SC.Shape$fieldShape,
                   minSize = 0.00)
                   
EX1.SC$objectSel[[4]] # Identifies 14 points, but point 6 and 9 are small artifacts
EX1.SC$objectReject[[4]] # No shape rejected because minSize = 0.00
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F21.jpeg">
</p>

<br />

```r
### When all shapes with size greater than 0.04% of plot area are counted: minSize = 0.04

EX1.SC<-fieldCount(mosaic = EX.SC.RemSoil$mask, 
                   fieldShape = EX.SC.Shape$fieldShape,
                   minSize = 0.04)

EX1.SC$objectSel[[4]] # Identifies 12 points
EX1.SC$objectReject[[4]] # Shows 2 artifacts that were rejected (6 and 9 from previous example)
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F22.jpeg">
</p>

<br />

> **`fieldCount`** also can be used to count other objects (e.g. seed, pollen, etc). The example below *FIELDimageR* pipeline was used to count seeds in a corn ear. 

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F28.jpg">
</p>

<br />

> **`fieldMask`** with index BIM (Brightness Index Modified) was used to identify pollen and **`fieldCount`** was used to count total and germinated pollens per sample.  [Download EX_Pollen.jpeg](https://drive.google.com/open?id=1Tyr4cEvEBoaWqaHw8UWPW-X1unzEMAfk)

<br />

```r
# Uploading image
EX.P<-stack("EX_Pollen.jpeg")

# Reducing image resolution (fast analysis)
EX.P<-aggregate(EX.P,fact=4) 
plotRGB(EX.P, r = 1, g = 2, b = 3)

# Shapefile using the entire image (extent = T)
EX.P.shapeFile<-polygonShape(EX.P,extent = T)

# Using index "BIM" to remove background (above 19)
EX.P.R1<- fieldMask(mosaic = EX.P,index = "BIM", cropValue = 19, cropAbove = T)
plotRGB(EX.P.R1$newMosaic)

# Counting all pollens above 0.01 size (all sample)
EX.P.Total<-fieldCount(mosaic = EX.P.R1$mask, fieldShape = EX.P.shapeFile$fieldShape, minSize = 0.01) 

# Using index "BIM" to identify germinated pollen grain (removing values above 16)
EX.P.R2<- fieldMask(mosaic = EX.P, index = "BIM", cropValue = 16, cropAbove = T)
plotRGB(EX.P.R2$newMosaic)

# Counting all germinated pollen above 0.005 
EX.P.<-fieldCount(mosaic = EX.P.R2$mask, fieldShape = EX.P.shapeFile$fieldShape, minSize = 0.005)

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F30.jpg">
</p>

[Menu](#menu)

<div id="P8" />

---------------------------------------------
#### 8. Evaluating the object area percentage (e.g. canopy)

> *FIELDimageR* can also be used to evaluate the canopy percentage per plot.  The *mask* output from **`fieldMask`** and the *fieldshape* output from **`fieldShape`** must be used. Function to use: **`fieldArea`**. The parameter *n.core* is used to accelerate the canopy extraction (parallel).

```r
EX1.Canopy<-fieldArea(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape)
EX1.Canopy$areaPorcent

### Parallel (n.core = 3)
EX1.Canopy<-fieldArea(mosaic = EX1.RemSoil$mask, fieldShape = EX1.Shape$fieldShape, n.core = 3)
EX1.Canopy$areaPorcent
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

<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/PotatoGrowthCycleNew.jpg" width="70%" height="70%">
</p>

<br />

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
#### 15. Building shapefile with polygons (field blocks, pest damage, soil differences, etc)

> If your field area does not have a pattern to draw plots using the function **fieldShape** you can draw different polygons using the function **polygonShape**. To make the fieldshape file the number of polygons must be informed. For instance, for each polygon, you should select at least four points at the polygon boundaries area. This function is recommended to make shapefile to extract data from specific field blocks, pest damage area, soil differences, etc. If *extent=TRUE* the whole image area will be the shapefile (used to analyze multiple images for example to evaluate seeds, ears, leaves, diseases, etc.). Function to use: **polygonShape**. The following example uses an image available to download here: [EX_polygonShape.tif](https://drive.google.com/open?id=1b42EAi3A3X54z00JWjFvsmUAm3yQClPk). 

```r
# Uploading file (EX_polygonShape.tif)
EX.polygon<-stack("EX_polygonShape.tif")
plotRGB(EX.polygon, r = 1, g = 2, b = 3)

# Removing soil
EX.polygon.RemSoil<- fieldMask(mosaic = EX.polygon)

# Data frame with polygons information
polygonData<-data.frame(ID=c("Polygon1","Polygon2","Polygon3"),
                        FlowerColor=c("white","white","white"),
                        FlowerPercent=c(20,40,50),
                        LeafColor=c("dark","light","dark"))
polygonData

# Building plot shapefile with 3 polygons (select 4 points around the polygon area)
EX.polygon.Shape<-polygonShape(mosaic = EX.polygon.RemSoil,
                               nPolygon = 3,nPoint = 4,ID = "ID",
                               polygonData = polygonData,cropPolygon = T,
                               polygonID = c("Polygon1","Polygon2","Polygon3"))
plotRGB(EX.polygon.Shape$cropField)

# Building indice (NGRDI and BGI)
EX.polygon.Indices<- indices(mosaic = EX.polygon.RemSoil$newMosaic, Red = 1, Green = 2, Blue = 3, 
                             index = c("NGRDI","BGI"))

# Extracting data (NGRDI and BGI)
EX.polygon.Info<- getInfo(mosaic = EX.polygon.Indices[[c("NGRDI","BGI")]],
                   fieldShape = EX.polygon.Shape$fieldShape, n.core = 3)
EX.polygon.Info$fieldShape@data

# Making graphics (BGI)
fieldPlot(fieldShape=EX.polygon.Info$fieldShape,
          fieldAttribute="BGI",
          mosaic=EX.polygon, color=c("red","blue"), alpha = 0.5)
```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F27.jpg">
</p>

[Menu](#menu)

<div id="P16" />

---------------------------------------------
#### 16. Making plots

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

<div id="P17" />

---------------------------------------------
#### 17. Saving output files

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

<div id="P18" />

---------------------------------------------
#### Orthomosaic using the open source software **[OpenDroneMap](https://www.opendronemap.org)**

> Image stitching from remote sensing phenotyping platforms (sensors attached to aerial or ground vehicles) in one orthophoto.

1) Follow the [OpenDroneMap’s documentation](https://docs.opendronemap.org/index.html) according to your operating system (Windows, macOS or Linux) to install [**WebODM**](https://www.opendronemap.org/webodm/).

2) Start [WebODM](https://www.opendronemap.org/webodm/) and **+Add Project** to upload your pictures (.tif or .jpg). Attached is one example of RGB images from experimental trials of [UW-Madison Potato Breeding and Genetics Laboratory](https://potatobreeding.cals.wisc.edu) during the flowering time at [Hancock Agricultural Research Station](https://hancock.ars.wisc.edu). Flight altitude was 60 m above ground, flight speed was 24 km/h, and image overlap was 75%. Donwload pictures [here](https://drive.google.com/open?id=1t0kjcBy6QzmIz_fVs6vsgZXi9Afqe09b).

3) After the running process '*completed*', download the **odm_orthophoto.tif** and **dsm.tif** to upload in R. Then follow the pipeline of *FIELDimageR*. [Donwload the final *odm_orthophoto.tif](https://drive.google.com/open?id=1XCDvbFdzHDmRA1dJSMp_veX_xC_ThiqC)*.

<br />

```r
# Uploading file (odm_orthophoto.tif):
EX.ODM<-stack("odm_orthophoto.tif")
plotRGB(EX.ODM, r = 1, g = 2, b = 3)

# Cropping the image to select only one trial (Selecting the same trial as EX.2 from step.13):
EX.ODM.Crop <- fieldCrop(mosaic = EX.ODM)

# Rotating the image using the same theta from step 3:
EX.ODM.Rotated<-fieldRotate(EX.ODM.Crop,theta = 2.3)

# Removing soil
EX.ODM.RemSoil<- fieldMask(mosaic = EX.ODM.Rotated)

# Building indices
EX.ODM.Indices <- indices(EX.ODM.RemSoil$newMosaic,Red=1,Green=2,Blue=3,
                 index = c("NGRDI","BGI"), myIndex = c("(Red-Blue)/Green"))

# Extracting data using the same fieldShape file from step 5:
EX.ODM.Info<- getInfo(mosaic = EX.ODM.Indices$myIndex,fieldShape = EX1.Shape$fieldShape,n.core = 3)

EX.ODM.Info$plotValue$myIndex

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/ODM_FIELDimageR_New.jpg">
</p>

[Menu](#menu)

<div id="P19" />

---------------------------------------------
#### Parallel and loop to evaluate multiple images

> The following code can be used to evaluate multiple images (e.g. root area, leave indices, damaged area, ears, seed, structures, etc.). The example below is evaluating disease damage in images of leaves (affected area and indices). Download the example [here](https://drive.google.com/open?id=1zgOZFd7KuTu4sERcG1wFoAWLCahIJIlu).

<br />

```r
# Images names (folder directory: "./images/")
pics<-list.files("./images/")

# Vegetation indices
index<- c("BGI","VARI","SCI")

############
### Loop ###
############

system.time({ # system.time: used to compare the processing time using loop and parallel
EX.Table.Loop<-NULL
for(i in 1:length(pics)){
  EX.L1<-stack(paste("./images/",pics[i],sep = ""))
  plotRGB(EX.L1)
  EX.L.Shape<-polygonShape(mosaic=EX.L1, extent=T, plot=F) # extent=T (The whole image area will be the shapefile)
  EX.L2<-fieldMask(mosaic=EX.L1, index="BGI", cropValue=0.8, cropAbove=T, plot=F) # Select one index to identify leaves and remove the background
  EX.L3<-fieldMask(mosaic=EX.L2$newMosaic, index="VARI", cropValue=0.1, cropAbove=T, plot=F) # Select one index to identify demaged area in the leaves  
  EX.L4<-indices(mosaic=EX.L2$newMosaic, index=index, plot=F) # Indices
  EX.L5<-stack(EX.L3$mask, EX.L4[[index]]) # Making a new stack raster with new layers (demage area and indices)
  EX.L.Info<- getInfo(mosaic=EX.L5, fieldShape=EX.L.Shape$fieldShape, projection=F) # projection=F (Ignore projection. Normally used only with remote sensing images)
  plot(EX.L5,col = grey(1:100/100))
  EX.Table.Loop<-rbind(EX.Table.Loop, EX.L.Info$plotValue) # Combine information from all images in one table
}})
rownames(EX.Table.Loop)<-pics
EX.Table.Loop

################
### Parallel ###
################

# Required packages
library(parallel)
library(foreach)
library(doParallel)

# Number of cores
n.core<-detectCores()-1

# Starting parallel
cl <- makeCluster(n.core, output = "")
registerDoParallel(cl)
system.time({
EX.Table.Parallel <- foreach(i = 1:length(pics), .packages = c("raster","FIELDimageR"), 
                     .combine = rbind) %dopar% {
                       EX.L1<-stack(paste("./images/",pics[i],sep = ""))
                       EX.L.Shape<-polygonShape(mosaic=EX.L1, extent=T, plot=F) # extent=T (The whole image area will be the shapefile)
                       EX.L2<-fieldMask(mosaic=EX.L1, index="BGI", cropValue=0.8, cropAbove=T, plot=F) # Select one index to identify leaves and remove the background
                       EX.L3<-fieldMask(mosaic=EX.L2$newMosaic, index="VARI", cropValue=0.1, cropAbove=T, plot=F) # Select one index to identify demaged area in the leaves  
                       EX.L4<-indices(mosaic=EX.L2$newMosaic, index=index, plot=F) # Indices
                       EX.L5<-stack(EX.L3$mask, EX.L4[[index]]) # Making a new stack raster with new layers (demage area and indices)
                       EX.L.Info<- getInfo(mosaic=EX.L5, fieldShape=EX.L.Shape$fieldShape, projection=F) # projection=F (Ignore projection. Normally used only with remote sensing images)
                       EX.L.Info$plotValue # Combine information from all images in one table
                     }})
rownames(EX.Table.Parallel)<-pics
EX.Table.Parallel 

```
<br />

<p align="center">
  <img src="https://github.com/filipematias23/images/blob/master/readme/F29.jpg">
</p>

[Menu](#menu)

<div id="P20" />

---------------------------------------------
#### Quick tips (image analyze in R)

1) [Changing memory limits in R](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Memory-limits.html)
```
# The rasterOptions() allows you to customize your R session (raster package): 
rasterOptions()
rasterOptions(chunksize = 1e+09)
rasterOptions(maxmemory = 1e+09)
```

2) [Reducing resolution for fast analysis](https://www.rdocumentation.org/packages/raster/versions/3.0-12/topics/aggregate)
```
new_mosaic<-aggregate(previous_mosaic, fact=4)
```

3) Removing previous files after used (more space in R memory): If you do not need one mosaic you should remove it to save memory to the next steps (e.g. the first input mosaic)
```
rm(previous_mosaic)
```

4) Using ShapeFile from other software (e.g. [QGIS](https://www.qgis.org/en/site/))
```
library(rgdal)
ShapeFile <- readOGR("Other_Software_ShapeFile.shp")
```

5) Combining ShapeFiles: sometimes it is better to split the mosaic into smaller areas to better draw the shapefile. For instance, the user can combine the split shapefiles to one for the next step as extractions
```
ShapeFile <- rbind(ShapeFile1, ShapeFile2, ShapeFile3, ...)
```

6) External window to amplify the RStudio plotting area (It helps to visualize and click when using functions: **fieldCrop**, **fieldRotate**, **fieldShape**, and **polygonShape**). The default graphics device is normally "RStudioGD". To change use "windows" on Windows, "quartz" on MacOS, and "X11" on Linux.
```
# Example in macOS (type the following code before running FIELDimageR functions):
options(device = "quartz")
```

[Menu](#menu)

<div id="P21" />

---------------------------------------------
### YouTube Tutorial

<br />

> FIELDimageR: A tool to analyze orthomosaic images from agricultural field trials in R (Basic Pipeline)
<p align="center">
<a href="https://youtu.be/ZXyaePAv9r8"><img src="https://github.com/filipematias23/images/blob/master/readme/YouTube.jpeg" width=400 height=300 title="Watch the video"></a>
</p>

> FIELDimageR: Counting the number of plants (fieldCount)
<p align="center">
<a href="https://youtu.be/v0gAq302Ueg"><img src="https://github.com/filipematias23/images/blob/master/readme/YouTubeSC.jpeg" width=400 height=300 title="Watch the video"></a>
</p>

> FIELDimageR: calculating vegetation indices (NDVI and NDRE)
<p align="center">
<a href="https://youtu.be/-XpSWKOXips"><img src="https://github.com/filipematias23/images/blob/master/readme/YouTubeIndices.jpeg" width=400 height=300 title="Watch the video"></a>
</p>

<br />

### Google Groups Forum

> This discussion group provides an online source of information about the FIELDimageR package.  

Report a bug and ask a question at https://groups.google.com/forum/#!forum/fieldimager

<br />

### Developers
> **Help improve FIELDimageR pipeline**. The easiest way to modify the package is by cloning the repository and making changes using [R projects](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects).

> If you have questions, join the forum group at https://groups.google.com/forum/#!forum/fieldimager

>Try to keep commits clean and simple

>Submit a **_pull request_** with detailed changes and test results.

**Let's  work together and help more people (students, professors, farmers, etc) to have access to this knowledge. Thus, anyone anywhere can learn how to apply remote sensing in agriculture.** 

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
