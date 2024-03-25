

#' Download State Data in Parallel
#'
#' Downloads Cropland Data Layer (CDL) composited data for a specified state and year
#' using CropScapeR::GetCDLComp function. The data for each county within the state is downloaded
#' in parallel and stored in a list, with each list element named after the county's FIPS code.
#'
#' @param State A character string specifying the state for which data is to be downloaded.
#' @param year An integer specifying the year for which data is to be downloaded.
#'
#' @return A list containing the downloaded CDL data for each county in the specified state.
#' Each element of the list is named by the county's FIPS code and contains the data as returned
#' by the CropScapeR::GetCDLComp function.
#'
#' @examples
#' \dontrun{
#'   alabama_data_2017 <- download_state_data_parallel(State = "AL", year = 2017)
#'   multiple_states_data_2017 <- download_state_data_parallel(State = c("SC","NC"), year = 2022)
#' }
#'
#' @importFrom dplyr filter
#' @importFrom future.apply future_lapply
#' @export
#' @useDynLib CropScapeR
download_state_data_parallel <- function(State, year) {
  load("./data/fips_csv.rda")
  # Filter data for the specified State
  fips_data_filtered <- dplyr::filter(fips_csv, state %in% State)

  data_list <- future.apply::future_lapply(seq_len(nrow(fips_data_filtered)), function(i) {
    # Download the data
    data <- CropScapeR::GetCDLComp(aoi = fips_data_filtered$fips[i], year1 = year, year2 = year, type = 'f')
    # Add a column for the year
    data$Year <- year
    return(data)
  }, future.seed = TRUE)

  # Assign names to the list elements based on the FIPS codes
  names(data_list) <- fips_data_filtered$fips

  return(data_list)
}


####################################################################################################
# Look up table for all land uses
#' Lookup Table for Land Uses
#'
#' A dataset containing the lookup table for all land uses, sourced from "./data-raw/Lookup_table.csv".
#' This dataset is used to map land use codes to their descriptions.
#'
#' @format A data frame with 136 rows and 2 columns
#' including columns such as 'Land use Code', 'Land use Description'.
#' @source Description of the Land use.
"Lookup_table"




