library(tidyverse)
library(rvest)

setwd("/Users/PhilipIpe/Documents/Data Science/Projects/NFL Analytics/Drafting")
master_df <- data.frame()
for (year in 1970:2016){
  
  draft_url <- paste("https://www.pro-football-reference.com/years/", year, "/draft.htm", sep="")
  draft_html <- read_html(draft_url)

  df <- draft_html %>%
    html_node("table") %>%
    html_table()

  names(df) <- as.character(unlist(df[1,]))
  df <- df[-1,]
  
  # get rid of the columns we dont care about
  df <- df[,1:13]
  
  df$Rnd <- as.integer(df$Rnd)
  df$Age <- as.integer(df$Age)
  df$CarAV <- as.integer(df$CarAV)
  df$DrAV <- as.integer(df$DrAV)
  df$G <- as.integer(df$G)
  
  # filter out certain rounds
  df <- df %>%
    filter(Rnd < 8)
  
  # get rid of blank rows
  df <-df[!(df$Player=="Player"),]
  
  # add year drafted to each observation
  df <- df %>%
    mutate(year = year)

  master_df <- rbind(master_df, df)
}

master_df$Rnd <- as.integer(master_df$Rnd)
master_df$Age <- as.integer(master_df$Age)
master_df$CarAV <- as.integer(master_df$CarAV)
master_df$DrAV <- as.integer(master_df$DrAV)
master_df$G <- as.integer(master_df$G)
write.csv(master_df, "rd1_4_draft.csv")
