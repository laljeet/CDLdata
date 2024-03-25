
### Filter and doenload data in parallel

library(tidyverse)
library(future)
library(future.apply)
library(CropScapeR)


# Determine the operating system and set up the appropriate future plan
if (.Platform$OS.type == "windows") {
  plan("multisession")
} else {
  # This is for Unix-like systems including macOS and Linux
  plan("multiprocess") # or use plan("multisession") if preferred
}


# Example function call
CDL_data_list <- CDLdata::download_state_data_parallel(State = c("SC"), year = 2022)

CDL_data <- purrr::map_df(CDL_data_list, tibble::as_tibble)
CDL_data$To <- NULL # Remove extra column

#####################################################################################

Remove_layers <- CDLdata::Lookup_table %>%
  filter(between(LC_code, 61,65)| between(LC_code,81,109) | between(LC_code,110,195))    # Forested, wetlands

AG_county_area <- CDL_data %>%
  filter(!From %in% Remove_layers$LC_type)


write.csv(AG_county_area, "Allcountiesdata.csv")
