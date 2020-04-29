library(reshape2)
library(lubridate)
library(dplyr)
library(ggplot2)

source('read.data.R')

# Fonte de dados:
# https://data.humdata.org/dataset/novel-coronavirus-2019-ncov-cases

options(scipen=999)

# Stats files
deathsFile = './time_series_covid19_deaths_global.csv'
confirmedFile = './time_series_covid19_confirmed_global.csv'
recoveredFile = './time_series_covid19_recovered_global.csv'

file = deathsFile
stats = 'Deaths'
fromdate = mdy('04.01.2020')

# southAmerica = c('Brazil', 'Argentina', 'Chile', 'Paraguay', 'Uruguay', 'Venezuela')
# europe = c('France', 'United Kingdom', 'Italy', 'Spain', 'Germany', 'Sweden')
brazilrope = c('France', 'United Kingdom', 'Italy', 'Spain', 'Germany', 'Sweden', 'Brazil')
# brazilnorthamerica = c('Brazil', 'US', 'Mexico', 'Canada')
bz_ec = c('Brazil', 'Ecuador')
bz_us = c('Brazil', 'US')
br_iran = c('Brazil', 'Iran')

countries = br_iran
data = lapply(countries, function(c) {
    readStats(file, stat = stats, cname = c, fromdate = fromdate)
}) %>% bind_rows()

# Daily values
gg = ggplot(data, aes(x = Date, y = Daily, group = Country.Region, colour = Country.Region))
gg + geom_line() + labs(title = stats)

# Cummean values
gg = ggplot(data, aes(x = Date, y = Cummean, group = Country.Region, colour = Country.Region))
gg + geom_line() + labs(title = stats)
