library(tidyverse)
library(lubridate)


player_information <- readRDS("Data/Raw/player-information.rds")
full_game_log <- readRDS("Data/Raw/full_game_log.rds")

full_game_log <- full_game_log %>%
  select(-starts_with("NA"))

names(full_game_log) <- c("Rk", "Game", "Date", "Age", "Team", "Venue", "Opponent", "Result", "GameStarted", "Minutes", "FGM", "FGA", "FGPerc", "FGM3", "FGA3", "FG3Perc",
                          "FTM", "FTA", "FTPerc", "ORB", "DRB", "TRB", "AST", "STL", "BLK", "TO", "PF", "PTS", "GameScore", "PlusMinus", "PlayerName", "PlayerId")

#########################################################
#----------- feature cleaning and engineering ----------#
#########################################################

#~~~~~~~~~~~~~~~~~~~~
# Game Logs
#~~~~~~~~~~~~~~~~~~~~
full_game_log <- separate(data = full_game_log, col = Result, into = c("Result", "Margin"), sep = "\\(")

full_game_log <- full_game_log %>%
  mutate(PlayerName = str_extract(PlayerName, "[^2018]+"),
         PlayOrNot = ifelse(GameStarted == "0" | GameStarted == "1", "Played", GameStarted))

full_game_log <- full_game_log %>%
  mutate(Date = ymd(Date),
         Age = as.numeric(str_replace(Age, "-", ".")),
         Venue = ifelse(Venue == "@", "Away", "Home"),
         Margin = as.numeric(str_replace(Margin, "\\)", "")),
         Minutes = as.numeric(ms(Minutes), "minutes"))

cols_to_numeric <- c("GameStarted", "FGM", "FGA", "FGPerc", "FGM3", "FGA3", "FG3Perc",
                     "FTM", "FTA", "FTPerc", "ORB", "DRB", "TRB", "AST", "STL", "BLK", "TO", "PF", "PTS", "GameScore", "PlusMinus")

full_game_log <- full_game_log %>%
  mutate_at(cols_to_numeric, as.numeric)

tail(full_game_log)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Season Player statistics
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
season_stats <- full_game_log %>%
  group_by(PlayerId, PlayerName) %>%
  summarise(TeamGames = n(),
            GP = sum(PlayOrNot == "Played", na.rm = T),
            AvgMinutes = mean(Minutes, na.rm = T),
            AvgPoints = mean(PTS, na.rm = T),
            Avg3PM = mean(FGM3, na.rm = T),
            AvgREB = mean(TRB, na.rm = T),
            AvgAST = mean(AST, na.rm = T),
            AvgSTL = mean(STL, na.rm = T),
            AvgBLK = mean(BLK, na.rm = T)) %>%
  ungroup() %>%
  mutate_if(is.character, str_squish)

head(season_stats)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Player Information
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
player_information$PlayerId <- str_remove(player_information$PlayerId, ".html")

player_information <- player_information %>%
  mutate(Experience = 2019 - From)


head(player_information)

# Join the average season stats back to the original player list
joined <- player_information %>%
  left_join(season_stats, by = "PlayerId")

# save data for inout to the app
saveRDS(joined, "app/data/PlayerSummaryStats.rds")




