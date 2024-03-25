Lookup_table <- read.csv("./data-raw/Lookup_table.csv")
Lookup_table <- dplyr::bind_rows(Lookup_table, data.frame(LC_code = 62, LC_type = "Grass/Pasture"))

usethis::use_data(Lookup_table, overwrite = TRUE)



# ### Load FIPS code csv
fips_csv <- read.csv("./data-raw/FIPS.csv")
usethis::use_data(fips_csv)



