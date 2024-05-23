#' @title Read Data Function
#'
#' @description Reads the dataset required for the following functions in the package and downloads it to the global environment.
#'
#' @param start A string where users should enter the word "yes".
#'
#' @return If users enter "yes", this returns the dataset and saves it. If not, users are prompted to enter "yes".
#'
#' @examples
#' # Download the dataset
#' read_data("yes")
#'
#' @export
read_data <- function(start) {
  if (tolower(start) == "yes") {
    url <- "https://raw.githubusercontent.com/asarafoglou-ptns/Zetea-LGBTQsafety/week1/LGBTQsafety/PTNS_countries_LGBTQ.csv"
    # Attempt to download and read the CSV file
    tryCatch({
      data <- read.csv(url)
      assign("data", data, envir = .GlobalEnv)
      return(data)
    }, error = function(e) {
      return(paste("An error occurred while downloading the dataset:", e$message))
    })
  } else {
    return("Type 'yes' to begin")
  }
}


#' @title Sexuality Law Function
#'
#' @description Display whether same-sex marriage is legal in a given country
#'
#' @param country A string representing a country listed in the dataset column "Country".
#'
#' @return A short word or phrase describing whether gay marriage is legal or illegal.
#'
#' @examples
#' # Check whether same sex marriage is legal in Uganda
#' sexuality_marriage_law("Uganda")
#'
#' @note
#' Using this package requires the dataset "PTNS_countries_LGBTQ.csv" which can be found in the package on GitHub.
#'
#' @export
sexuality_marriage_law = function(country) {
  if (country %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == country)
    # Return the value of same.sex.marriage to show laws for the country
    return(data$same.sex.marriage[row_index])
  } else {
    return(paste("Country", country, "not available."))
  }
}


#' @title Gender Change Law Function
#'
#' @description Display under what conditions legal gender change is possible in a given country.
#'
#' @param country A string representing country listed in the dataset column "Country".
#'
#' @return A short word or phrase describing if/how legal gender change is possible.
#'
#' @examples
#' # Check whether gender change is legal in Canada.
#' gender_change_law("Canada")
#'
#' @note
#' Using this package requires the dataset "PTNS_countries_LGBTQ.csv" which can be found in the package on GitHub.
#'
#' @export
gender_change_law = function(country) {
  if (country %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == country)
    # Return the value of gender.ID.expression to show laws for that country
    return(data$gender.ID.expression[row_index])
  } else {
    return(paste("Country", country, "not available."))
  }
}

#' @title Discrimination Law Function
#'
#' @description Display whether laws prevent LGBTQ+ discrimination in a given country.
#'
#' @param country A string representing country listed in the dataset column "Country".
#'
#' @return A short word or phrase describing whether laws prevent forms of discrimination based on gender identity or sexuality.
#'
#' @examples
#' # Check whether laws exist to prevent discrimination in Mexico.
#' discrimination_law("Canada")
#'
#' @note
#' Using this package requires the dataset "PTNS_countries_LGBTQ.csv" which can be found in the package on GitHub.
#'
#' @export
discrimination_law = function(country) {
  if (country %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == country)
    # Return the value of gender.ID.expression to show laws for that country
    return(data$anti.discrimination.laws.sexual.orientation[row_index])
  } else {
    return(paste("Country", country, "not available."))
  }
}
