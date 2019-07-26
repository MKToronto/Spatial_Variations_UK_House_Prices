data_gb@data %>%
  ggplot(aes(x=younger_adults, y=Mean))+ 
  geom_point(aes(fill=Mean, size=Price),colour="#525252",pch=21) +
  stat_smooth(method=lm, se=FALSE, size=1, colour="#525252")+
  scale_fill_distiller("BrBG", type="div", direction=1, guide="colourbar", limits=c(-0.29,0.29))+
  theme_bw()+
  theme(legend.position="none")+
  ggtitle(paste("correlation:",round(cor.test(data_gb@data$Mean,data_gb@data$younger_adults)$estimate,2)))
