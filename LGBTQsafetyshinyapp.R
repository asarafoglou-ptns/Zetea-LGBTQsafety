
#Open the required packages
library(shiny)
library(bslib)
library(dplyr)
library(LGBTQsafety)


# Define UI ----
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
     textInput("country", label = NULL)
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
       )
     )
   )
 )


# Define server logic ----
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
     req(dataset())  # Ensure the dataset is loaded
     country <- input$country
     discrimination_law(country)
   })
   
   #Text output for safety rating
   output$safe <- renderText({
     req(dataset())  # Ensure the dataset is loaded
     country <- input$country
     safety_rating(country)
   })
}

# Run the app ----
shinyApp(ui = ui, server = server)