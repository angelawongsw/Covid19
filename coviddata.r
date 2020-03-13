
library(stringr)
library(httr)

#read all the lines from the website
weblines <- readLines('https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide')

#extrac all lines that contains .xls
weblines_xls <- weblines[grep("\\.xls",weblines)]

#extract the data url
covid_xls <- head(stringr::str_extract(weblines_xls,"http.+?xls"),1)

#save the file to temp file in the computer
GET(covid_xls, write_disk(tf <- tempfile(fileext = ".xls")))

#get the data updated date time 
updated_datetime<- weblines[grep("title.+?Situation update worldwide.+?title.+?",weblines)] %>%
  str_extract(pattern="\\d.+?00") %>%
  head(1)

#to read excel file
library(readxl) 
library(countrycode)

#read the data into R
data <- read_excel(tf)

#include continent into the dataset
data <- cbind(data,data.frame("Continent" = countrycode(sourcevar = unlist(data[, "CountryExp"]),origin = "country.name",destination = "continent"),stringsAsFactors = FALSE)
)


#remove the unused dataset or list
rm(list = ls(pattern = "lines|tf|xls"))
