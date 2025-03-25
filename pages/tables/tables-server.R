# turn selected table into a reactive object
dataset_input <- reactive({
  tables[[input$table]] %>% 
    mutate(across(is.numeric,
                  ~formatC(., format = 'f', digits = 3, big.mark = ",",
                           drop0trailing = TRUE)))
})

# DT table output
output$table_data <- renderDT({
  dataset_input()
})

# DT table download table
output$download_table_data <- downloadHandler(
  filename = function() {
    paste(input$table, ".csv", sep = "")
  },
  content = function(file) {
    write.csv(dataset_input(), file, row.names = FALSE)
  }
)

# table name
output$table_title <- renderPrint(
  report_titles_list[[input$table]]
  )