# Note that we use the 'optimal' bandwidth derived from the bw.gwr() function.
gw_ss <- gwss(data_gb, vars  =  c("Leave", "younger_adults", "white" , "christian", "english_speaking", "single_ethnicity_household", "own_home", "not_good_health", "degree_educated", "no_car", 
                                  "private_transport_to_work", "professionals"),
              kernel = "bisquare", adaptive = TRUE, bw = 50, quantile = TRUE)

tm_shape(gw_ss$SDF) +
  tm_fill(col=colnames(gw_ss$SDF@data[127:137]), title="gwr coefficients", style="cont",palette="PRGn", size=0.2) + 
  tm_borders(col="#bdbdbd", lwd=0.5) +
  tm_facets(free.scales = FALSE) +
  tm_layout(
    title=colnames(gw_ss$SDF@data[127:137]),
    frame=FALSE,
    title.snap.to.legend=FALSE,
    title.size=1,
    title.position = c("left", "top"),
    inner.margins = c(0,0,0.15,0),
    legend.title.size=1,
    legend.text.size=0.6,
    legend.outside=TRUE)