# turn selected sfr into a reactive object
sfr_input <- reactive({
  sfrs[[input$sfr]] %>% 
    mutate(across(is.numeric,
                  ~formatC(., format = 'f', digits = 3, big.mark = ",",
                           drop0trailing = TRUE)))
})

# DT table output
output$sfr_data <- renderDT({
  sfr_input()
})

# DT table download table
output$download_sfr_data <- downloadHandler(
  filename = function() {
    paste(input$sfr, ".csv", sep = "")
  },
  content = function(file) {
    write.csv(sfr_input(), file, row.names = FALSE)
  }
)