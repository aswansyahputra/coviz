## code to prepare `idn_mobility` dataset goes here

library(vroom)
library(dplyr)
library(tidyr)
library(stringr)

global_mobility <-
  vroom(
    "https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv?cachebust=e0c5a582159f5662",
    col_types = cols(
      country_region_code = col_character(),
      country_region = col_character(),
      sub_region_1 = col_character(),
      sub_region_2 = col_character(),
      date = col_date(format = ""),
      retail_and_recreation_percent_change_from_baseline = col_double(),
      grocery_and_pharmacy_percent_change_from_baseline = col_double(),
      parks_percent_change_from_baseline = col_double(),
      transit_stations_percent_change_from_baseline = col_double(),
      workplaces_percent_change_from_baseline = col_double(),
      residential_percent_change_from_baseline = col_double()
    )
  )

indonesia_mobility <-
  global_mobility %>%
  filter(
    country_region == "Indonesia",
    !is.na(sub_region_1)
  ) %>%
  rename_all(~ str_remove(.x, "_percent_change_from_baseline")) %>%
  pivot_longer(
    cols = c(retail_and_recreation:residential),
    names_to = "category",
    values_to = "pct_changes"
  ) %>%
  transmute(
    province = sub_region_1,
    date,
    category = str_replace_all(category, "_", " ") %>%
      str_to_title(),
    pct_changes = pct_changes / 100
  ) %>%
  arrange(province, category, date)

usethis::use_data(indonesia_mobility, overwrite = TRUE)
