# Load Libraries
library(tidyverse)
library(httr)
library(rvest)
library(lubridate)


#---------- For the whole table of information ----------#

html1 <- "https://www.basketball-reference.com/players/"

surname_initial <- letters
players_temp_ref <- c()
active_players_temp_ref <- c()
player_information <- data.frame(Player = as.character(), From = as.character(), To = as.character(), Pos = as.character(), Ht = as.character(),
                                 Wt = as.character(), Birth.Date = as.character(), Colleges = as.character(), PlayerId = as.character())

i <- NULL

for(i in 1:length(surname_initial)) {
  
  tryCatch(test <- read_html(paste0(html1, surname_initial[i], "/")), error = function(e) { test <- NA })
  
  players_temp_ref <- html_attr(html_nodes(test, "tr") %>% html_nodes("th a"), "href")
  active_players_temp_ref <- html_attr(html_nodes(test, "tr") %>% html_nodes("strong a"), "href")
  
  test1 <- html_table(test, ".sortable stats_table strong", header = T) %>% data.frame()
  test1$PlayerId <- players_temp_ref
  
  test1 <- test1 %>% filter(PlayerId %in% active_players_temp_ref)
  
  player_information <- rbind(player_information, test1)
  
}

player_information <- player_information %>%
  filter(To == 2020) %>%
  distinct(.keep_all = T)

#---------- Scraper to get each player's game log ----------#

main_url <- "https://www.basketball-reference.com"
player_urls <- player_information$PlayerId %>% str_remove(".html")

year_log <- "/gamelog/2020"

full_urls <- paste0(main_url, player_urls, year_log)

j <- NA
player_table <- NA

player_table <- data.frame(Rk = as.character(), G = as.character(), Date = as.character(), Age= as.character(), Tm = as.character(), X. = as.character(),
                           Opp = as.character(), X..1 = as.character(), GS = as.character(), MP = as.character(),  FG = as.character(), FGA = as.character(),
                           FG. = as.character(), X3P = as.character(), X3PA = as.character(), X3P. = as.character(), FT = as.character(),
                           FTA = as.character(), FT. = as.character(), ORB = as.character(), DRB = as.character(), TRB = as.character(), AST = as.character(),
                           STL = as.character(), BLK = as.character(), TOV = as.character(), PF = as.character(), PTS = as.character(),  GmSc = as.character(),
                           X... = as.character())

full_game_log <- data.frame(Rk = as.character(), G = as.character(), Date = as.character(), Age= as.character(), Tm = as.character(), X. = as.character(),
                            Opp = as.character(), X..1 = as.character(), GS = as.character(), MP = as.character(),  FG = as.character(), FGA = as.character(),
                            FG. = as.character(), X3P = as.character(), X3PA = as.character(), X3P. = as.character(), FT = as.character(),
                            FTA = as.character(), FT. = as.character(), ORB = as.character(), DRB = as.character(), TRB = as.character(), AST = as.character(),
                            STL = as.character(), BLK = as.character(), TOV = as.character(), PF = as.character(), PTS = as.character(),  GmSc = as.character(),
                            X... = as.character(), PlayerName = as.character(), PlayerId = as.character())


output <- data.frame(Rk = as.character(), G = as.character(), Date = as.character(), Age= as.character(), Tm = as.character(), X. = as.character(),
                     Opp = as.character(), X..1 = as.character(), GS = as.character(), MP = as.character(),  FG = as.character(), FGA = as.character(),
                     FG. = as.character(), X3P = as.character(), X3PA = as.character(), X3P. = as.character(), FT = as.character(),
                     FTA = as.character(), FT. = as.character(), ORB = as.character(), DRB = as.character(), TRB = as.character(), AST = as.character(),
                     STL = as.character(), BLK = as.character(), TOV = as.character(), PF = as.character(), PTS = as.character(),  GmSc = as.character(),
                     X... = as.character(), PlayerName = as.character(), PlayerId = as.character())


# the below scrape took ~ 22 minutes to complete

start_time <- Sys.time()

for(j in player_urls) {
  try({
    each_url <- read_html(paste0(main_url, j, year_log))
    
    player_table <- html_table(each_url, ".table_outer_container", header = T, fill = T)[8] %>% data.frame() %>% select(1:30) %>% filter(Rk != "Rk")
    PlayerName <- html_nodes(each_url, "h1") %>%  html_text()
    PlayerId <- j
    
    output <- cbind(player_table, PlayerName, PlayerId)
    
    full_game_log <- bind_rows(full_game_log, output)
  }, silent = TRUE)
}

(end_time <- Sys.time() - start_time)



# Save Data files for building the app
saveRDS(player_information, "Data/Raw/player-information.rds")
saveRDS(full_game_log, "Data/Raw/full_game_log.rds")

rm(list = ls());gc()
