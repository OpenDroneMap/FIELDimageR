
latlon_crs<-crs('+proj=longlat +datum=WGS84 +no_defs')
latlon_shape<-spTransform(EX1.Shape$fieldShape, latlon_crs)

multi_polys<-attr(latlon_shape, 'polygons')
json<-'{"type": "FeatureCollection", "name": "FIELDimageR", "features": ['
npolys<-length(multi_polys)
separator<-''
for (i in 1:npolys) {
  poly<-multi_polys[[i]]
  polys<-attr(poly, 'Polygons')
  coords<-coordinates(polys[[1]])
  ncoords<-dim(coords)[[1]]
  json<-paste(json, separator, '{"type": "Feature", "properties": { "id": "', c(i), '", "observationUnitName":"', c(i), '"}, "geometry": { "type": "Polygon", "coordinates": [ [ ')
  coord_separator<-''
  for (c in 1:ncoords) {
    json<-paste(json, coord_separator, "[", coords[c, 1], ",", coords[c, 2], "]")
    coord_separator<-', '
  }
  json<-paste(json, "] ] } }")
  separator<-', '
}
json<-paste(json, ']}')


fileConn<-file("plots.json")
writeLines(json,fileConn)
close(fileConn)

