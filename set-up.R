#' set-up.R
#' Health Finance & Analytics
#' Code written March 2025
#' R version 4.1.2 (2021-11-01)
#'
#' Author: Maiana Sanjuan
#' Runtime:
#' Memory:
#' CPUs:
#'
# set-up ---

# parameters
version_suffix <- "-v23_24"


# Public Health Scotland package are not on CRAN, install if necessary
if (!requireNamespace("phsmethods", quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsmethods")
}

if (!requireNamespace("phsstyles", quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsstyles")
  
}

# Install {curl} v5.2.3
# install.packages("curl", repos = "https://ppm.publichealthscotland.org/all-r/__linux__/centos7/2024-11-04+Y3JhbiwzOjIyNzUsNDoyMjQ5LDU6MjM4OCw2Ojg2Myw3OjIzNjksODoyMzE0OzI4MkU4MzFE")

library(janitor)
library(here)
library(glue)
library(tidyr)
library(dplyr)
library(magrittr)
library(phsmethods)
library(stringr)
library(shinyWidgets)
library(shinycssloaders)
library(rsconnect)
library(shinymanager)
library(bslib)
library(readxl)
library(DT)


# load functions ----

source(here("functions", "core-functions.R"))

# filepaths ----

import_data_path <- here("..", "outputs")
tables_path <- here(import_data_path, "raw-tables")
sfrs_path <- here(import_data_path, "SFRs")
templates_dir <- here("..", "costs_book", "templates")

files <- list(
  tables = list.files(
    tables_path, full.names = TRUE, include.dirs = FALSE), 
  sfrs =  list.files(
    sfrs_path, full.names = TRUE, include.dirs = FALSE)
)

file_names <-list(
  tables = list.files(
    tables_path, full.names = FALSE, include.dirs = FALSE),
  sfrs = list.files(
    sfrs_path, full.names = FALSE, include.dirs = FALSE)
)


file_names$tables <- file_names$tables[!(grepl("R100-subsets", file_names$tables))]

# import data ----

# tables and SFRs
tables <- lapply(files$tables[!grepl("R100-subsets", files$tables)], read_excel)
sfrs <- lapply(files$sfrs, read.csv)

names(tables) <- gsub(glue("{version_suffix}.xlsx"), "", file_names$tables)
names(sfrs) <- gsub(glue("{version_suffix}.csv"), "", file_names$sfrs)

# get report titles
report_titles_df <- read_excel(
  here("reference-files", "costs_report_logic_2024.xlsx"), skip = 4) %>%
  clean_names() %>% 
  select(report_number, report_title) %>% 
  filter(!is.na(report_number)) %>% 
  mutate(report_number = ifelse(report_number %in%  c("R086", "R020", "R020LS","R025"), 
                gsub("R", "D", report_number), report_number)) %>% 
  distinct()

report_titles_list <- report_titles_df$report_title
names(report_titles_list) <- report_titles_df$report_number

# subset tables to only keep unique data (many downloads and reports are duplicates)
tables <- tables[names(tables) %in% names(report_titles_list)]
