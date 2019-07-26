# For spatial data handling
library(rgdal)
library(spdep)
library(rgeos)
# For charting
library(tmap)
library(cartogram)
library(ggplot2)
library(gridExtra)
library(GGally)
# For data loding and munging
library(readr)
library(dplyr)
# For spatial stats
library(GWmodel)
library(spdep)
# For regression functions
library(car)
# For cluster analysis
library(cluster)

# Read .csv containing referendum results data into an R DataFrame. A DataFrame consisting of 378 observations 
# and 8 variables should appear in your RStudio Data pane. Click on this entry or enter View(referendum_data) 
# to inspect the DataFrame as a spreadsheet.  
#London Data
#house_price_data_london<- read_csv("duplicates_removed_UK_LA.csv")
# pc_la_lookup <- read.csv("london_postcodes1.csv")
 #house_price_data_london <- left_join(house_price_data, pc_la_lookup)
#Manchester data



# Read .csv containing 2011 Census data.  
census_data<- read_csv("./census/data/2011_census_oa.csv")
oa_la_lookup <- read.csv("./census/data/oa_la_lookup.csv")
census_data <- left_join(census_data, oa_la_lookup)
# Iterate over OA level data and compute summary statistics on relevant variables to LA level.
census_data <- census_data %>%
  group_by(LOCAL_AUTHORITY_CODE) %>%
  summarise(
    total_pop = sum(Total_Population),
    younger_adults = sum(Age_20_to_24, Age_25_to_29, Age_30_to_44) / sum(Total_Population), 
    white = sum(White_British_and_Irish) / sum(Total_Population),
    christian = sum(Christian) / sum(Total_Population),
    english_speaking = sum(Main_language_is_English_or_Main_language_not_English__Can_speak_English_very_well)
    / sum(Total_Population),
    single_ethnicity_household = sum(All_household_members_have_the_same_ethnic_group) 
    / sum(Total_Households),
    own_home = sum(Owned_and_Shared_Ownership) / sum(Total_Households),
    not_good_health = sum(Fair_health, Bad_health, Very_bad_health) / sum(Total_Population),
    degree_educated = sum(Highest_level_of_qualification_Level_4_qualifications_and_above) / 
      sum(Highest_level_of_qualification_Level_4_qualifications_and_above,
          Highest_level_of_qualification_Level_3_qualifications,
          Highest_level_of_qualification_Level_1_Level_2_or_Apprenticeship,
          No_qualifications),
    no_car = sum(No_cars_or_vans_in_household) / sum(Total_Households),
    private_transport_to_work = sum(Private_Transport) / sum(Total_Employment_16_to_74),
    professionals = sum(Managers_directors_and_senior_officials, Professional_occupations) /
      sum(Total_Employment_16_to_74)
  )

# Read in shapefile containing GB LA boundaries. 
gb_boundaries <- readOGR(dsn = "Output_Area_December_2011_Full_Extent_Boundaries_in_England_and_Wales", layer = "Output_Area_December_2011_Full_Extent_Boundaries_in_England_and_Wales")
# Set coordinate system -- in this case OSGB: https://epsg.io/27700.
proj4string(gb_boundaries) <- CRS("+init=epsg:27700")
# Note that "gb_boundaries" is an R SpatialDataFrame. A DataFrame containing LA names, codes and
# summary statistics can be accessed through "gb_boundaries@data" 
gb_boundaries@data$geo_code <- as.character(gb_boundaries@data$geo_code)
# Re-label LAs where codes in gb_boundaries are deprecated.
gb_boundaries@data$geo_code[gb_boundaries@data$geo_code=="E41000052"] = "E06000052"
gb_boundaries@data$geo_code[gb_boundaries@data$geo_code=="E41000324"] = "E09000033"
# Merge results and census data with SpatialDataFrame containing LA geomoetries. We do so with the 
# inner_join function. This is provided by the "dplyr" package; for a description enter "?inner_join" 
# into the Console.
gb_boundaries@data <- left_join(gb_boundaries@data, house_price_data_london,  by=c("geo_code" =  "LA_Code"))
gb_boundaries@data <- inner_join(gb_boundaries@data, census_data, by=c("geo_code" =  "LOCAL_AUTHORITY_CODE"))
# Let's rename this SpatialDataFrame now containing the boundary information and the attribute data. 
data_gb <- gb_boundaries
# In order keep a clean workspace, remove the redundant data.
rm(census_data)
rm(house_price_data_london)
rm(gb_boundaries)
# For the results maps in the first exercise we'll create a new column: majority % points in favour of Leave:Remain. 
# We again use a function specfic to the "dplyr"package -- mutate(). dplyr also uses the "%>%" piping operator that 
# allows better structuring and nesting of calls to "dplyr ". This is provided by the "magrittr" package, which you 
# might have noticed being installed along with "dplyr". For a description, type "?magrittr" into your R Console. 
# We'll also calculate another variable that might be discriminating: population density.
# data_gb@data <- data_gb@data %>%
#   mutate(leave_remain = Leave-0.5,
#          population_density = total_pop/AREA) 