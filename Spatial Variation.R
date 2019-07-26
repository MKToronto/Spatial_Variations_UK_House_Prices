# A SpatialDataFrame must always be supplied to tm_shape(). To tm_fill(), we identify the variable values 
# on which polygons should be coloured as well as information such as the colour mapping (sequential, diverging 
# or continuous) and palette to use. Many, many layout specifications are available in tm_layout. Type ?tm_layout
# into the Console for a complete list.
tm_shape(data_gb) +  
  tm_fill(col="Mean",style="cont",palette="BrBG", size=0.2, id="geo_label", title="") + 
  tm_borders(col="#bdbdbd", lwd=0.5) +
  # tm_facets("Region name", free.coords=TRUE) +
  tm_layout(
    title="house prices",
    title.snap.to.legend=TRUE,
    title.size=0.8,
    legend.text.size=0.6,
    title.position = c("right", "center"),
    legend.position = c("right","center"),
    frame=FALSE,
    legend.outside=TRUE)

tm_shape(data_gb) +  
  tm_fill(col="Mean",style="cont",palette="BrBG", size=0.2, id="geo_label", title="") + 
  tm_borders(col="#bdbdbd", lwd=0.5)
# Build your map in the same way as in the Choropleth example. However, before the call to tm_layout() add:
tm_facets("Region", free.coords=TRUE) +
  
  # We construct a new SpatialDataFrame, using the cartogram() function, passing as a parameter into the function, 
  # the variable with which we wish to size polygons: Electorate (number of voters in LA).
  data_gb_carto <- cartogram(data_gb, "Electorate", itermax=5)
# To create the cartogram, supply precisely the same parameters to the tmap library as appear in the Choropleth example.
# However, rather than passing data_gb to tm_shape, pass data_gb_carto:
# e.g. tm_shape(data_gb_carto) +
#   ...


# Interactive mode.
tmap_mode("view")
# Re-run your code that generates the Choropleth or cartogram in order to return the interactive version. Note that interactively is currently not availaable for the faceted map. 
# e.g. tm_shape(data_gb) +
#        ... 
# To reset back to static mode:
tmap_mode("plot")