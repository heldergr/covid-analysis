readData <- function(filename, stat) {
    d <- read.csv(filename) %>%
        select(-c('Lat', 'Long')) %>%
        melt(id.vars = c('Province.State', 'Country.Region'))
    d$Date = mdy(substring(d$variable, 2, 8))
    d = select(d, -c('variable')) %>%
        rename(Value = value)
    d = aggregate(Value ~ Country.Region + Date, data = d, FUN = sum)    
    d$Stat = stat
    d
}

addDailyValue <- function(data) {
    e = data
    e$Daily = e$Value
    values = e$Value
    for (i in 2:nrow(e)) {
        e[['Daily']][i] = values[i] - values[i-1]     
    }
    e
}

readStats <- function(filename, stat, cname = NULL, fromdate = NULL) {
    f = readData(filename, stat)
    if (!is.null(cname)) {
        f = filter(f, Country.Region == cname)
        f = addDailyValue(f)
        f$Cummean = cummean(f$Daily)
    }
    if (!is.null(fromdate)) {
        f = filter(f, Date >= fromdate)
        # Rerun the cummean calculation to consider only the selected range
        f$Cummean = cummean(f$Daily)
    }
    f
}