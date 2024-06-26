#' @title Read and Calculate Data Function
#'
#' @description Reads the data set required for the following functions, converts string values in the columns same.sex.sexual.activity, same.sex.marriage, gender.ID.expression and anti.discrimination.laws.sexual.orientation for calculating safety ratings, and downloads the dataset to the global environment. 
#'
#' @param start A string where users should enter the word "yes".
#'
#' @return If users enter "yes", this returns the dataset and saves it. If not, users are prompted to enter "yes".
#'
#' @examples
#' # Download the dataset
#' read_and_calculate_data("yes")
#'
#' @note
#' Using this package requires the dataset "PTNS_countries_LGBTQ.csv", and also requires the dplyr package.
#' 
#' @export
read_and_calculate_data <- function(start) {
  if (tolower(start) == "yes") {
    url <- "https://raw.githubusercontent.com/asarafoglou-ptns/Zetea-LGBTQsafety/week1/LGBTQsafety/PTNS_countries_LGBTQ.csv"
    
    # Attempts to download and read the CSV file
    data <- tryCatch({
      read.csv(url)
    }, error = function(e) {
      stop(paste("An error occurred while downloading the dataset:", e$message))
    })
    
    # Converts Sexual Activity Law column to numerical
    numeric_sexual_activity <- function(number) {
      case_when(
        number == "Legal" ~ 5,
        number == "Male illegal, female legal" ~ 2,
        number == "Illegal" ~ 1,
        TRUE ~ 3
      )
    }
    
    # Convert Anti Discrimination Law column to numerical
    numeric_discrim_law <- function(number) {
      case_when(
        number == "all banned" ~ 5,
        number == "All banned" ~ 5,
        number == "No" ~ 1,
        number == "no" ~ 1,
        TRUE ~ 3
      )
    }
    
    # Converts Gender Identity Law column to numerical
    numeric_gndr_ID <- function(number) {
      case_when(
        number == "Legal" ~ 5,
        number == "Legal after surgery" ~ 4,
        number == "Legal with surgery" ~ 4,
        number == "Legal change to 3rd gender" ~ 4,
        number == "3rd gender (hijra) allowed" ~ 4,
        number == "Documents can be amended" ~ 4,
        number == "Legal after surgery and sterilization" ~ 3,
        number == "Legal with surgery and sterilization" ~ 3,
        number == "Legal after medical intervention" ~ 3,
        number == "Illegal" ~ 1,
        TRUE ~ 3
      )
    }
    
    # Converts Same Sex Marriage Law column to numerical
    numeric_same_sex_marriage <- function(number){
      case_when(
        number == "Legal" ~ 5,
        number == "Illegal" ~ 1,
        TRUE ~ 3
      )
    }
    
    # Adds converted columns to dataset
    data <- data %>%
      mutate(
        numeric_activity = numeric_sexual_activity(Same.sex.sexual.activity),
        numeric_disc = numeric_discrim_law(anti.discrimination.laws.sexual.orientation),
        numeric_gndr = numeric_gndr_ID(gender.ID.expression),
        numeric_marriage = numeric_same_sex_marriage(same.sex.marriage)
      )
    
    # Assigns the dataset to a variable in the global environment
    assign("data", data, envir = .GlobalEnv)
    
    return(data)
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


#' @title Safety Rating Function
#'
#' @description Displays safety rating of a given country on a scale from 1 to 5. This is calculated using laws regarding legal status of homosexuality, same-sex marriage, gender change, and discrimination.
#'
#' @param country A string representing country listed in the dataset column "Country".
#'
#' @return A number between 1 and 5 which represents a safety rating.
#'
#' @examples
#' # Check the overall safety rating for LGBTQ+ individuals in China.
#' safety_rating("China")
#'
#' @note
#' Using this package requires the dataset "PTNS_countries_LGBTQ.csv" which can be found in the package on GitHub.
#'
#' @export
safety_rating = function(country) {
  if (country %in% data$Country) {
    # Finds the row corresponding to the entered country
    row_index <- which(data$Country == country)
    numeric_columns <- data[row_index, c("numeric_activity",
                                         "numeric_marriage", 
                                         "numeric_disc", 
                                         "numeric_gndr")]
    rating <- mean(as.numeric(unlist(numeric_columns)))
    return(paste("The safety rating is", rating, "out of 5"))
  } else {
    return(paste("Country", country, "not available."))
  }
  
}

#' @title Open App Function
#'
#' @description Runs the LGBTQsafety app in R shiny, where the previous functions are utilized with a GUI.
#'
#' @examples
#' # Run the app in R shiny
#' open_app()
#'
#'@note 
#'This function requires the "shiny", "bslib", "dplyr", and "LGBTQsafety" packages to be loaded.
#'
#' @export
open_app <- function(){
  #Open the required packages
  #library(shiny)
  #library(bslib)
  #library(dplyr)
  #library(LGBTQsafety)
  
  # Define UI
  ui <-page_fluid(
    titlePanel("LGBTQ Safety Calculator"),
    theme = bs_theme(
      preset = "vapor",
      bg = "#15ed44",
      fg = "#0af3ff",
      primary = "#ff0afb",
      secondary = "#1B1BFB",
      success = "#F0FB1B"
    ),
    
    sidebarPanel(
      helpText("With this app, you can see which laws affect LGBTQ+ 
             people in any country! Press the start button to begin.")
    ),
    
    mainPanel(
      card(
        card_header("Click here first!"),
        actionButton("start", "Start")
      ),
      
      card(
        card_header("Choose a country!"),
        textInput("country", label = NULL),
        helpText("Countries should be capitalized and written with the correct English spelling")
      ),
      
      layout_columns(
        col_width = 2,
        
        card(
          card_header("Is same sex marriage legal?"),
          textOutput("ssm_lgl")
        ),
        
        card(
          card_header("Is gender change legal?"),
          textOutput("gndr_chng")
        ),
        
        card(
          card_header("Any forms discrimination against LGBTQ+ people banned?"),
          textOutput("dscrm")
        ),
        
        card(
          card_header("Safety rating for LGBTQ+ individuals?"),
          textOutput("safe")
        ),
        
        helpText("Please note: in countries with a very low safety rating, punishments
             and prison sentences may apply. For more information, see this link:
             https://en.wikipedia.org/wiki/LGBT_rights_by_country_or_territory"),
        
      )
    )
  )
  
  # Define server logic
  server <- function(input, output, session) {
    
    #A reactive expression loads the dataset when "start" button is pressed
    dataset <- eventReactive(input$start, {
      read_and_calculate_data("yes")
    })
    
    # Observe the dataset and print a message when it loads
    observe({
      if (is.data.frame(dataset())) {
        print("Dataset loaded successfully.")
      } else {
        print(dataset())
      }
    })
    
    #Text output for same-sex marriage laws
    output$ssm_lgl <- renderText({
      req(dataset())  
      country <- input$country
      sexuality_marriage_law(country)
    })
    
    #Text output for gender change laws
    output$gndr_chng <- renderText({
      req(dataset())  
      country <- input$country
      gender_change_law(country)
    })
    
    #Text output for anti-discrimination laws
    output$dscrm <- renderText({
      req(dataset())  
      country <- input$country
      discrimination_law(country)
    })
    
    #Text output for safety rating
    output$safe <- renderText({
      req(dataset())
      country <- input$country
      safety_rating(country)
    })
  }
  
  # Run the app
  shinyApp(ui = ui, server = server)
}