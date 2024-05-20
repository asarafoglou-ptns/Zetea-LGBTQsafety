#set working directory to file with this dataset
data = read.csv("PTNS_countries_LGBTQ.csv")
data

#' @title Sexuality Law Function
#'
#' @description Display whether same-sex marriage is legal in a given country
#'
#' @param a A string representing a country listed in the dataset column "Country".
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
sexuality_marriage_law = function(a) {
  if (a %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == a)
    # Return the value of same.sex.marriage to show laws for the country
    return(data$same.sex.marriage[row_index])
  } else {
    return(paste("Country", a, "not available."))
  }
}


#' @title Gender Change Law Function
#'
#' @description Display under what conditions legal gender change is possible in a given country.
#'
#' @param a A string representing country listed in the dataset column "Country".
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
gender_change_law = function(a) {
  if (a %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == a)
    # Return the value of gender.ID.expression to show laws for that country
    return(data$gender.ID.expression[row_index])
  } else {
    return(paste("Country", a, "not available."))
  }
}

library(LGBTQsafety)
