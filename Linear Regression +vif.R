lm(Leave ~ christian + english_speaking + degree_educated + white + no_car, data = data_gb@data)

# Generate correlation coefficient matrix
data_gb@data %>% 
  select(Leave, younger_adults, white, christian, english_speaking, single_ethnicity_household,
         own_home, not_good_health, degree_educated, no_car, private_transport_to_work, professionals, population_density) %>%
  ggcorr(label=TRUE,nbreaks=5,  geom = "text", hjust = 1, size = 3, palette = "RdBu", label_alpha=0.1)

# Look again at Scotland using a call to filter().
data_gb@data %>% 
  filter(Region == "Scotland") %>%
  ...

# Calculate VIF scores
vif(lm(Leave ~ younger_adults + white + christian + english_speaking + single_ethnicity_household + own_home + not_good_health + degree_educated + no_car + private_transport_to_work + professionals + population_density, data=data_gb@data))


vif(lm(Leave ~ younger_adults + ..., data=data_gb@data))
