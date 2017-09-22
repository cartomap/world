library(tidyverse)
library(sf)

country_shp <- st_read("./CNTR_2014_03M_SH/Data/CNTR_RG_03M_2014.shp") %>% 
  select(id = 1)

country <- readLines(file("./countries.txt", encoding = "UTF16"))
writeLines(country, "../data/country.csv")

country <- 
  read_delim("../data/country.csv", "\t") %>% 
  select( id = edwin.Veld1
        , sl_code = `Code Landen`
        , name_org = Veld2
        , name_nl = `Land Nederlands`
        , name_en = `Land Engels`
        ) %>% 
  filter(!is.na(sl_code))

write_csv(country, "../data/country.csv")

country_shp <- 
  left_join(country_shp, country)

st_write(country_shp, "./world_raw.shp", delete_layer = TRUE)
