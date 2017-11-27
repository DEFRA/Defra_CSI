#Prepare non EU exports data from https://www.uktradeinfo.com/Statistics/Pages/Data-Downloads-Archive.aspx 
#download the files "SMKE" under Traders.  
#2017 data available here: https://www.uktradeinfo.com/Statistics/Pages/DataDownloads.aspx

#load required packages ----
library(readr) #makes importing data easier
library(tidyverse) #loads a suite of useful data manipulation packages


#I saved my files in subfolders data and then uktradeinfo, i.e. "data/uktradeinfo/"
#the files are called SMKE191601.txt - the last digit is the month, so there are 12 of them. 


#import the data ----
files <- dir(pattern = "SMKE", path = "data/uktradeinfo/", full.names = TRUE) 
  #find all files containing 'SMKE' and save into an object
files

nonEUexp.raw <- files %>% # read in all the files individually, using
  map(read_delim, col_names = FALSE, skip = 1, delim = "|", trim_ws = TRUE, quote = "") %>% 
  head(-1) %>% #remove last row
  reduce(rbind) # reduce with rbind into one dataframe 

warnings()
summary(nonEUexp.raw) # have a closer look

length(unique(as.numeric(nonEUexp.raw$X1)))

nrow(unique(nonEUexp.raw))

#8,356 unique values in x1; 2,119,048 unique rows (of 2,119,048) - i.e. all unique

#no more processing

nonEUexp <- nonEUexp.raw

names(nonEUexp) <- c("COMCODE", "SITC", "RECORD-TYPE", 
                         "COD-SEQUENCE", "COD-ALPHA", "ACCOUNT-MM_CCYY", 
                         "PORT-SEQUENCE", "PORT-ALPHA", "FLAG-SEQUENCE", 
                         "FLAG-ALPHA", "TRADE-INDICATOR", "CONTAINER", 
                         "MODE-OF-TRANSPORT", "INLAND-MOT", "GOLO-SEQUENCE", 
                         "GOLO-ALPHA", "SUITE-INDICATOR", "PROCEDURE-CODE", 
                         "VALUE", "QUANTITY-1", "QUANTITY-2", 
                         "INDUSTRIAL-PLANT-COMCODE")


######got this far
summary(nonEUexp) #

apply(nonEUexp, 2, function(x)length(unique(x)))


#tidy up
rm(nonEUexp.raw, files)

#export data ---
write_csv(nonEUexp, "data/nonEUexp2016data.csv")

