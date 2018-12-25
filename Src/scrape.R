library(tidyverse)
library(httr)
library(rvest)
library(lubridate)


og_webpage <- read_html("https://www.basketball-reference.com/players/a/anunoog01/gamelog/2019")


og_table <- html_table(og_webpage, ".table_outer_container", header = T, fill = T) %>% data.frame() %>% select(15:44) %>% filter(Rk != "Rk")

player_name <- html_nodes(og_webpage, "h1") %>%  html_text()




#---------- For the whole table of information ----------#

html1 <- "https://www.basketball-reference.com/players/"

surname_initial <- letters
players_temp_ref <- c()
active_players_temp <- c()
active_players_temp_ref <- c()
active_players <- c()
full_table <- data.frame(Player = as.character(), From = as.character(), To = as.character(), Pos = as.character(), Ht = as.character(),
                         Wt = as.character(), Birth.Date = as.character(), Colleges = as.character(), PlayerId = as.character())

i <- NULL
for(i in 1:length(surname_initial)) {
  
  tryCatch(test <- read_html(paste0(html1, surname_initial[i], "/")), error = function(e) { test <- NA })
  
  players_temp_ref <- html_attr(html_nodes(test, "tr") %>% html_nodes("th a"), "href")
  active_players_temp_ref <- html_attr(html_nodes(test, "tr") %>% html_nodes("strong a"), "href")
  
  test1 <- html_table(test, ".sortable stats_table strong", header = T) %>% data.frame()
  test1$PlayerId <- players_temp_ref
  
  test1 <- test1 %>% filter(PlayerId %in% active_players_temp_ref)
  
  
  
  
  full_table <- rbind(full_table, test1)
  
}


















