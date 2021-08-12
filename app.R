
library(tidyverse)
library(shiny)

# Create df

df <- data.frame("Food" = c(rep("Ice Cream", 6), rep("Chips", 6)),
                   "Category" = c(rep("Chocolate", 3),
                                  rep("Vanilla", 3),
                                  rep("Corn", 3),
                                  rep("Potato", 3)),
                   "Type" = c("Dark", "Milk", "Bittersweet", 
                              "French", "Swiss", "Natural",
                              "Reduced Salt", "Low Fat", "White", 
                              "BBQ", "Ranch", "Plain"))

# create selection options for food (first filter)

my_food <- df %>% 
    pull(Food) %>% 
    unique()

ui <- fluidPage(

    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "food",
                        label = "Food", 
                        # Default - nothing is selected
                        choices = c("",my_food)),
            # These will be conditional panels:
            uiOutput(outputId = "cond_1",
                     container = tags$div),
            uiOutput(outputId = "cond_2",
                     container = tags$div)),

        # Dummy placeholder
        mainPanel(
           
        )
    )
)

server <- function(input, output) {
    
    # Create Category UI
    output$cond_1 <- renderUI({
        
        # create category options per a particular food selection
        my_categories <- df %>% 
            filter(Food == input$food) %>% 
            pull(Category) %>% 
            unique()
        
        # only show category options for a particular food selection
        conditionalPanel(
            condition = "input.food !=''",
            selectInput(inputId = "category",
                        label = "Category",
                        # I want nothing to be selected
                        choices = c("", my_categories))
            
        )
        
    })
    
    # Create Type UI
    output$cond_2 <- renderUI({
        
        # create Type options for a particular food and category
        my_types <- df %>% 
            filter(Food == input$food & 
                       Category == input$category) %>% 
            pull(Type) %>% 
            unique()
        
        # only show type options for particular food/category selection
        conditionalPanel(
            condition = "input.category !=''",
            selectInput(inputId = "types",
                        label = "Type",
                        #Again, don't want anything to be selected
                        choices = c("",my_types)) 
        )
        
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
