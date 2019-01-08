# NBA-Fantasy-Experience
The purpose of this project is to be able to build a tool that I can use in my Yahoo NBA fantasy leagues.

The dynasty league that I am in has a requirement of having at least on rookie on our active lists, and a further two rookies or second year players on our rosters. Yahoo doesn't have "experience" as a field that you can filter/search on, so I needed a way to be able to identify eligible players that I'm required to have on my roster.

## Morphing
From there, I decided that it might be handy to have game logs for each player, to be able to visualise trends throughout the seasons in the key statistics (points, minutes, rebounds, steals, blocks, assists, fantasy points), rather than have to rely on numerical summaries (averages, etc).

# The Data
The data has been sourced from Basketball Reference's site https://www.basketball-reference.com/.

Game logs for each of the active players in the 2018-2019 season have been collected.

# Project Instructions
The below steps should be followed when using the app:

1. First run the scraper: https://github.com/JaseZiv/NBA-Fantasy-Experience/blob/master/Src/scrape.R
2. The scraper will save the data in the repo as an rdata file: https://github.com/JaseZiv/NBA-Fantasy-Experience/tree/master/Data/Raw
3. Then run the following file to preprocess the data: https://github.com/JaseZiv/NBA-Fantasy-Experience/blob/master/Src/DataPreprocessing.R
4. This will then save the data for the app in the app sub-directory: https://github.com/JaseZiv/NBA-Fantasy-Experience/tree/master/app/data 
5. Finally, the app is ready to run: https://github.com/JaseZiv/NBA-Fantasy-Experience/blob/master/app/app.R

