# Select variables used as input to clustering: gw-correlation coefficients
gw_correlations <- gw_ss$SDF[,c(127:137)]
colnames(gw_correlations@data)[1:11] <- colnames(data_gb@data[14:24])
gw_correlations$geo_label <- data_gb@data$geo_label

# Create distance matrix -- we z-score standardise the variables to ensure that no single variable 
# has undue weight due to its distribution.
dist_matrix <- gw_correlations@data %>%
  select(christian , white  , not_good_health , degree_educated , no_car) %>%
  mutate_each(funs(z = .-mean(.)/sd(.)))
dist_matrix <- dist(dist_matrix[,6:10])

# HCA using the Ward's method.
hclustering_ward <- hclust(dist_matrix, method="ward.D2")
# PLot dendrogram
plot(hclustering_ward)

# Evaluate ASW values at different cuts of the dendrogram.
avg.sil.width <- function(cluster_solution, min_cut, max_cut, dist_matrix)
{
  for (i in min_cut:max_cut)
  {
    print(c(i,summary(silhouette(cutree(cluster_solution,k = i), dist_matrix))$avg.width))
  }
}
avg.sil.width(hclustering_ward, 2, 12, dist_matrix)
# Plot of silhuoette profile to evaluate stability of individual groups -- notice that cluster group 2 is 
# particularly poorly defined.
plot(silhouette(cutree(hclustering_ward,4),dist_matrix))
# Add cluster membership as a variable to gw_correlations SpatialDataFrame.
cluster_groups <- cutree(hclustering_ward,4)
gw_correlations@data$cluster_groups <- cluster_groups

tm_shape(gw_correlations) +
  tm_fill(col="cluster_groups", style="cat",id="geo_label", palette="Accent", size=0.2) + 
  tm_borders(col="#636363", lwd=0.2) +
  tm_facets(free.scales = FALSE) +
  tm_layout(
    frame=FALSE,
    title.size=1,
    title.position = c("left", "top"),
    inner.margins = c(0,0,0.15,0),
    legend.title.size=1,
    legend.text.size=0.6,
    legend.outside=TRUE)

gw_correlations@data %>%    
  gather(c(2,3,7,8,9),key="corr_type", value="corr_value") %>%
  group_by(corr_type) %>%
  ggplot(aes(x=corr_value, fill=as.factor(cluster_groups))) +
  geom_density(colour ="#636363") +
  xlim(-1,1) +
  geom_vline(xintercept = 0, colour ="#636363", linetype = "dashed") +
  scale_fill_brewer(type = "qual", palette = "Accent") +
  facet_wrap(~cluster_groups+corr_type) +
  theme_classic()+
  theme(legend.position="none", 
        strip.text.x = element_blank()
  )