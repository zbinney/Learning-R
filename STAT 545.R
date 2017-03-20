##### INTRO TO R COURSE (STAT 545) ######

  #Test to ensure I have R, RStudio installed correctly
  
  x <- 2*4 # "X gets 2 times 4"
  x #Bingo, working
  
  #Install some basic packages we'll need for course
  #install.packages(c("dplyr","tidyr","ggplot2","rmarkdown"), dependencies = TRUE)
  
  #Try out a function
  seq(1, 10)
  
  #Create (and print!) a couple more objects
  (yo <- "hello, world")
  (y <- seq(1, 10))
  date1 <- date()
  
  #List all objects I have created (user-defined objects)
  objects()
  #rm(list=objects()) #Removes all objects
  
  #Remove single object
  rm(date1) 

  #Check working directory
  getwd()
  
  
  
  
  
  
  
  
##### DATA EXPLORATION, GAPMINDER, DPLYR (Classes 4-6, 8) #####
  
  #Get gapminder data
  #install.packages("gapminder")
  library(gapminder)
  
  #Get flights data
  #install.packages("nycflights13")
  library(nycflights13)
  
  #Check structure of Gapminder data
  str(gapminder)
  
  #Install tidyverse
  #install.packages("tidyverse")
  library(tidyverse)
  
  #Now that tidyverse - and by extension tibbles - are loaded, let's print Gapminder
  class(gapminder)
  gapminder
  
  #Gapminder was a tibble, but if it weren't...
  as_tibble(gapminder)
  as_tibble(gapminder)
  
  #Get statistical overview of Gapminder
  summary(gapminder)
  
  #Plot life expectancy by year from Gapminder
  plot(lifeExp ~ year, gapminder)
  
  #Plot life expectancy by GDP per capita from Gapminder
  plot(lifeExp ~ gdpPercap, gapminder)
  
  #Plot life expectancy by log(GDP) per capita from Gapminder
  plot(lifeExp ~ log(gdpPercap), gapminder)
  
  #Investigate single continuous variable (lifeExp) from Gapminder data
  head(gapminder$lifeExp) #Prints first 6 observations
  summary(gapminder$lifeExp)
  hist(gapminder$lifeExp)
  table(gapminder$lifeExp) #Gives a count of each level of the variable
  class(gapminder$lifeExp)
  
  #Investigate single integer variable (year) from Gapminder data
  head(gapminder$year) #Prints first 6 observations
  summary(gapminder$year)
  hist(gapminder$year)
  table(gapminder$year) #Gives a count of each level of the variable
  class(gapminder$year)
  levels(gapminder$year) #Function only for categorical variables
  
  #Investigate single categorical variable (continent) from Gapminder data
  head(gapminder$continent) #Prints first 6 observations
  summary(gapminder$continent)
  #hist(gapminder$continent) only for numeric variables
  table(gapminder$continent) #Gives a count of each level of the variable
  class(gapminder$continent)
  levels(gapminder$continent)
  nlevels(gapminder$continent)
  
  #Check to see that continent is actually stored as an integer "under the hood" by R
  str(gapminder$continent)
  
  #Count continents by category, and plot that
  contable <- table(gapminder$continent)
  contable
  barplot(contable)
  
  #Do some plotting with ggplot2 before you really know what's going on
  p <- ggplot(filter(gapminder, continent != "Oceania"),
              aes(x = gdpPercap, y = lifeExp)) # just initializes
  p <- p + scale_x_log10() # log the x axis the right way
  p + geom_point() # scatterplot
  p + geom_point(aes(color = continent)) # map continent to color
  p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE)
  p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) +
    geom_smooth(lwd = 1.5, se = FALSE)
  
  
  #Filter by an aspect of a row
    
    #Life expectancy under 30
    filter(gapminder, lifeExp < 30)
  
    #Rwanda, after 1979
    filter(gapminder, country == "Rwanda", year > 1979)
    
    #Rwanda or Afghanistan
    filter(gapminder, country %in% c("Afghanistan", "Rwanda"))
    
    
  #Pipes ("then") to help with nested operations
  
    #Print first 6 (default) observations from Gapminder
    gapminder %>% head()
    
    #Print first 3 observations from Gapminder
    gapminder %>% head(3)
    
    #Only give me observations with life expectancy under 30
    gapminder %>% filter(lifeExp < 30)
    
  
  #Subset data by column
    
    #Two equivalent ways to get first 4 rows of just year and life expectancy
    head(select(gapminder, year, lifeExp), 4)
    
    gapminder %>%  
      select(year, lifeExp) %>% 
        head(4)
    
  #Create (and print) copy of Gapminder for myself
    (zach_gap <- (gapminder))
    
    #Print output to screen, but don't store
    zach_gap %>%  filter(country=="Canada")
    
    #Store output in new object
    zach_gap_can <- zach_gap %>%  filter(country=="Canada")
    #zach_gap_can
    
  
  #Adding variables  
  #Add new variable for GDP (per capita GDP x pop) to my copy of Gapminder
  zach_gap %>%
    mutate(gdp = pop * gdpPercap)
  
  #Add new variable that is per capita GDP as a fraction of Canada's per capita GDP
  #NOTE: This would be better done with a join, but we don't know those yet
  zach_gap_can <- zach_gap %>%
    filter(country == "Canada") #Create subset of Canada's GDP by year
  
  zach_gap <- zach_gap %>% 
    mutate(tmp = rep(zach_gap_can$gdpPercap, nlevels(country)), #Create new variable tmp 
           #that takes Canada's GDP for a given year and adds those values to dataset
           #replicated for each country
           gdpPercapRel = gdpPercap/tmp, #Create new variable that holds GDP/Canada's GDP for that year
           tmp = NULL) #Delete variable tmp
  
    #Sanity checks for new GDP relative-to-Canada variable
    zach_gap %>% 
      filter(country=="Canada") %>%
        select(country, year, gdpPercapRel) #All values 1 --> pass
    
    summary(zach_gap$gdpPercapRel) #Most values below 1 --> pass (Canada high-income)
    
    
  #Sorting data
    
    #Sort by year, then country
    zach_gap %>%
      arrange(year, country)
    
    #Sort data from 2007 on life expectancy in ASCENDING order
    zach_gap %>%
      arrange(lifeExp) %>% 
      filter(year=="2007")
    
    #Sort data from 2007 on life expectancy in DESCENDING order
    zach_gap %>%
      arrange(desc(lifeExp)) %>% 
      filter(year=="2007")
    
    #NOTE: All of these sorts are just printed - 
    #none of them is made to the underlying frame/tibble!
    
  
  #Renaming variables
    
    #From camelCase to snake_case
    zach_gap_rename <- zach_gap %>%
      rename(life_exp = lifeExp,
             gdp_percap = gdpPercap,
             gdp_percap_rel = gdpPercapRel)
    
    #NOTE: these variable names are now changed in new frame/tibble zach_gap_rename
    
  
  #Renaming and re-ordering variables
    
    # Create table for just Burundi, from 1996 and later, with Per Capita GDP as first column
    # followed by year (as "yr") and life expectancy
    zach_gap %>%
      filter(country=="Burundi", year > 1996) %>% 
      select(yr = year, lifeExp, gdpPercap) %>% 
      select(gdpPercap, everything())
    
    
  #Processing and summarizing data BY GROUP
    
    #Count number of observations per continent in Gapminder
    zach_gap %>%
      group_by(continent) %>% 
      summarize(n=n()) # Take each group of n=[size of current group] observations
                       # and return a single row with count
    
      #Two more convenient ways to accomplish this
      zach_gap %>%
        group_by(continent) %>%
        tally()
      
      zach_gap %>%
        count(continent)
      
    #Count number of DISTINCT countries per continent in Gapminder
    zach_gap %>%
      group_by(continent) %>% 
      summarize(n=n(), n_countries=n_distinct(country))
    
    #Average life expectancy by continent
    zach_gap %>% 
      group_by(continent) %>% 
      summarize(avg_le = mean(lifeExp)) #NOTE: These are averages across all time
    
    #Average and median per capita GDP and life expectancy by
    #continent and year, for 1952 and 2007
    zach_gap %>%
      filter(year %in% c(1952, 2007)) %>% 
      group_by(year, continent) %>% 
      summarize_each(funs(mean, median), lifeExp, gdpPercap)
    
    #Minimum and maximum life expectancies in Asia each year
    zach_gap %>%
      filter(continent=="Asia") %>%
      group_by(year) %>% 
      summarize(min_lifeExp = min(lifeExp), max_lifeExp=max(lifeExp))
      #NOTE: This code won't show us WHICH country is max and min. We'll tackle soon
    
  
  #Calculations BY GROUP (i.e. with group-level summary data)
    
    #Life expectancy gains/losses for each country, relative to 1952
    zach_gap %>%
      group_by(country) %>%
      select(country, year, lifeExp) %>%  #Choose these 3 variables
      mutate(lifeExp_gain = lifeExp - first(lifeExp)) #first() takes first value of life
                                                      #expectancy in each country/group (i.e. 1952)
    
  
  #Window functions: instead of n inputs --> 1 output, n inputs --> n outputs
    
    #Minimum and maximum life expectancies in Asia each year, showing the countries
    zach_gap %>%
      filter(continent=="Asia") %>%
      select(year, country, lifeExp) %>% 
      group_by(year) %>% 
      filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>%
      #min_rank filters through years and ranks each country's life expectancy.
      #Then, we filter for rows that are the most extreme on either end!
      arrange(year) %>%
      print(n = Inf)
    
  
  #CHALLENGE: which country exhibited greatest 5-year drop in life expectancy, by continent?
    zach_gap <- arrange(zach_gap, year) #Sorting has no effect on below code
    zach_gap_change <- zach_gap %>%
      select(country, continent, year, lifeExp) %>% 
      group_by(continent, country) %>% 
      mutate(le_change_5y = lifeExp - lag(lifeExp))
      #This creates new dataset with a variable representing 5-year change in life expectancy.
      #New variable is automatically "NA" for first (earliest) observation within each country.
  
    zach_gap_maxchange <- zach_gap_change %>%
      group_by(continent) %>% 
      filter(min_rank(le_change_5y) < 2)
      #Within each continent, retain the worst life expectancy change
    
    