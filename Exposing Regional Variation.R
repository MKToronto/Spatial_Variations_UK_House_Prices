# Create models based on the degree variable only
m_gb_degrees <- lm(Leave~ degree_educated, data=data_gb@data)
data_gb@data$resids_gb_degrees <- resid(m_gb_degrees)

# Create models based a selection of variables (we chose by taking VIF scores and other contextual considerations into account)
m_gb_refined <- lm(Leave ~ christian + english_speaking + degree_educated + white + no_car, data=data_gb@data)
data_gb@data$resids_gb_refined <- resid(m_gb_refined)

tm_shape(data_gb) + 
  tm_fill(col=c("resids_gb_degrees","resids_gb_refined"),style="cont",palette="RdBu", id="geo_label",size=0.2, title="") + 
  tm_borders(col="#bdbdbd", lwd=0.5)+
  tm_facets(free.scales = FALSE)+
  tm_layout(
    frame=FALSE,
    fontfamily = "Avenir LT 45 Book",
    title=c("Degree-educated","Refined multivariate"),
    title.size=1,
    title.position = c("left", "top"),
    inner.margins = c(0,0,0.15,0),
    legend.title.size=1,
    legend.text.size=0.6,
    legend.outside=TRUE)