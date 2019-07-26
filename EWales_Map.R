tm_shape(data_gb) +  
  tm_fill(col="Mean",style="cont",palette="BrBG", size=0.2, id="geo_label", title="") + 
  tm_borders(col="#bdbdbd", lwd=0.5) +
  # tm_facets("Region name", free.coords=TRUE) +
  tm_layout(
    title="Mean House Prices in the UK 2016",
    title.snap.to.legend=TRUE,
    title.size=1.5,
    legend.text.size=0.6,
    title.position = c("right", "center"),
    legend.position = c("right","center"),
    frame=FALSE,
    legend.outside=TRUE)

tm_shape(data_gb) +  
  tm_fill(col="own_home",style="cont",palette="BrBG", size=0.2, id="geo_label", title="") + 
  tm_borders(col="#bdbdbd", lwd=0.5) +
  tm_facets("Region name", free.coords=TRUE) +
  tm_layout(
    title="Home Ownership in the UK 2016",
    title.snap.to.legend=TRUE,
    title.size=1.5,
    legend.text.size=0.6,
    title.position = c("right", "center"),
    legend.position = c("right","center"),
    frame=FALSE,
    legend.outside=TRUE)



tm_shape(data_gb) +
  tm_polygons(c("own_home", "Mean"), 
              style=c("pretty", "kmeans"),
              palette=list("RdYlGn", "Purples"),
              auto.palette.mapping=FALSE,
              title=c("Home Ownership", "Mean House Price 2016")) +
  tm_format_Europe() + 
  tm_style_grey()


data_gb_carto_pop<- cartogram(data_gb, "total_pop", itermax=5)
#Cartogram to show population weighted
tm_shape(data_gb_carto_pop) +  
  tm_fill(col="Mean",style="cont",palette="BrBG", size=0.2, id="geo_label", title="") + 
  tm_borders(col="#bdbdbd", lwd=0.8) +
  # tm_facets("Region name", free.coords=TRUE) +
  tm_layout(
    title="Mean house price weigyted by Total population in the UK 2016",
    title.snap.to.legend=TRUE,
    title.size=1.5,
    legend.text.size=0.6,
    title.position = c("right", "center"),
    legend.position = c("right","center"),
    frame=FALSE,
    legend.outside=TRUE)

#Cartogram to show mean house prices
data_gb_carto_mean_price<- cartogram(data_gb, "Mean", itermax=5)

tm_shape(data_gb_carto_mean_price) +  
  tm_fill(col="Mean",style="cont",palette="BrBG", size=0.2, id="geo_label", title="") + 
  tm_borders(col="#bdbdbd", lwd=0.8) +
  # tm_facets("Region name", free.coords=TRUE) +
  tm_layout(
    title="Mean House Prices in the UK 2016 weighted by mean house price ",
    title.snap.to.legend=TRUE,
    title.size=1.5,
    legend.text.size=0.6,
    title.position = c("right", "center"),
    legend.position = c("right","center"),
    frame=FALSE,
    legend.outside=TRUE)


data_gb@data %>%
  ggplot(aes(x=younger_adults, y=own_home))+ 
  geom_point(aes(fill=own_home, size=total_pop),colour="#525252",pch=21) +
  stat_smooth(method=lm, se=FALSE, size=1, colour="#525252")+
  scale_fill_distiller("BrBG", type="div", direction=1, guide="colourbar", limits=c(-0.29,0.29))+
  theme_bw()+
  theme(legend.position="none")+
  ggtitle( paste("Relationship of home ownership to younger adults 
                 Correlation:",round(cor.test(data_gb@data$own_home,data_gb@data$younger_adults)$estimate,2)))

# Put variables in correct syntax
data_gb@data$Mean_House_Price = data_gb@data$Mean
data_gb@data$Region_name = data_gb@data$`Region name`

# Draw Correlation Scatter Plot

p <- ggplot(data_gb@data, aes(younger_adults, own_home))
p + geom_point(aes(colour = Mean_House_Price, size=Mean_House_Price)) +
ggtitle( paste("Relationship between Younger Adults and Own Home 
                 Correlation:",round(cor.test(data_gb@data$younger_adults,data_gb@data$own_home)$estimate,2)))




stat_smooth(method=lm, se=FALSE, size=1, colour="#525252")+
  scale_fill_distiller("BrBG", type="div", direction=1, guide="colourbar", limits=c(-0.29,0.29))+
  theme_bw()+
  theme(legend.position="none")+
  
# Generate correlation coefficient matrix
data_gb@data %>% 
  select(Mean_House_Price, younger_adults, white, christian, english_speaking, single_ethnicity_household,
         own_home, not_good_health, degree_educated, no_car, private_transport_to_work, professionals) %>%
  ggcorr(label=TRUE,nbreaks=5,  geom = "text", hjust = .9, size =2, palette = "RdBu", label_alpha=.1)

# Look again at Scotland using a call to filter().
data_gb@data %>% 
  filter(Region == "Scotland") %>%
  ...

# Calculate VIF scores
vif(lm(Mean_House_Price ~ own_home + not_good_health + degree_educated  + private_transport_to_work , data=data_gb@data))
# summary
summary(lm(Mean_House_Price ~  degree_educated  + private_transport_to_work , data=data_gb@data))
# Create models based on the degree variable only
m_gb_degrees <- lm(Mean_House_Price ~  degree_educated, data=data_gb@data)

# Create models based a selection of variables (we chose by taking VIF scores and other contextual considerations into account)
m_gb_refined <- lm(Mean_House_Price ~ own_home + not_good_health + degree_educated  + private_transport_to_work , data=data_gb@data)
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