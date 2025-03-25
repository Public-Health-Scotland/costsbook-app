tagList(
  # select a sfr
  selectizeInput("sfr", "Pick a Scottish Financial Return: ", names(sfrs)), 
  
  # Download Button
  downloadButton("download_sfr_data", "Download"), 
  
  # DT output
  DTOutput("sfr_data")
)