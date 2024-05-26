
#Open the required packages
library(shiny)
library(bslib)
library(dplyr)

#Define read_data function for use
read_data <- function(start) {
  if (tolower(start) == "yes") {
    url <- "https://raw.githubusercontent.com/asarafoglou-ptns/Zetea-LGBTQsafety/week1/LGBTQsafety/PTNS_countries_LGBTQ.csv"
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

#Define sexuality_marriage_law for use
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

# Define UI ----
ui <-page_fluid(
  titlePanel("LGBTQ Safety Calculator"),
  theme = bs_theme(
    preset = "vapor",
    bg = "#8600D9",
    fg = "#00D9A5",
    primary = "#D900C4",
    secondary = "#1B1BFB",
    success = "#F0FB1B",
    ),
  layout_columns(
    col_width = 2,
    
    card(
      card_header("Click here first!"),
      actionButton("start", "Start")
    ),
    
    card(
      card_header("Choose a country!"),
      textInput("country", label = NULL)
    ),
  
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
  )
  )
)


# Define server logic ----
server <- function(input, output, session) {

 #Loads the dataset when "start" button is pressed
   dataset <- eventReactive(input$start, {
    read_data("yes")
  })
  
   # Observe the dataset and print a message when it's loaded
   observe({
     if (is.data.frame(dataset())) {
       print("Dataset loaded successfully.")
     } else {
       print(dataset())
     }
   })
   
   output$ssm_lgl <- renderText({
     req(dataset()) #Make sure dataset is loaded
     country <- input$country
     sexuality_marriage_law(country)
   })
   
   output$gndr_chng <- renderText({
     req(dataset()) #Make sure dataset is loaded
     country <- input$country
     if (country %in% dataset()$Country) {
       row_index <- which(dataset()$Country == country)
       return(dataset()$gender.ID.expression[row_index])
     } else {
       return(paste("Country", country, "not available."))
     }
   })
   
   output$dscrm <- renderText({
     req(dataset())  # Make sure dataset is loaded
     country <- input$country
     if (country %in% dataset()$Country) {
       row_index <- which(dataset()$Country == country)
       return(dataset()$anti.discrimination.laws.sexual.orientation[row_index])
     } else {
       return(paste("Country", country, "not available."))
     }
   })
   
}

# Run the app ----
shinyApp(ui = ui, server = server)


