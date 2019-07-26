# load this package to use HTTP verbs
library(httr)
install.packages("PostcodesioR")
library(PostcodesioR)

postcode_lookup <- function(postcode) {
  r <- GET(paste0("https://api.postcodes.io/postcodes/", postcode))
  warn_for_status(r)
  content(r)
}

# returns a list
pc_content <- postcode_lookup("EC1Y 8LX")
admin_district_value <- postcode_lookup(postcode)$result$codes$admin_district


house_price_data$AC <- mapply(postcode_lookup(house_price_data$PostCode)$result$codes$admin_district, house_price_data$PostCode)

