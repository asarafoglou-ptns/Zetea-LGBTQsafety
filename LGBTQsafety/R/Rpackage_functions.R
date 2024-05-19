data = read.csv("PTNS_countries_LGBTQ.csv")
data

#' @export
sexuality_marriage_law = function(a) {
  if (a %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == a)
    # Return the value of same.sex.marriage to show laws for the country
    print(data$same.sex.marriage[row_index])
  } else {
    print(paste("Country", a, "not available."))
  }
}


sexuality_marriage_law("Tuvalu")
sexuality_marriage_law("Lisbon")

#' @export
gender_change_law = function(a) {
  if (a %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == a)
    # Return the value of gender.ID.expression to show laws for that country
    print(data$gender.ID.expression[row_index])
  } else {
    print(paste("Country", a, "not available."))
  }
}

gender_change_law("Saudi Arabia")
gender_change_law("Romania")
gender_change_law("Hogwarts")
