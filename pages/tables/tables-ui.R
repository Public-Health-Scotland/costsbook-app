tagList(
  # select a table
  selectizeInput("table", "Pick a Costbook Table: ", names(tables)), 
  
  #report title
  uiOutput("table_title"),
  
  # Download Button
  downloadButton("download_table_data", "Download"), 
  
  # DT output
  DTOutput("table_data")
)