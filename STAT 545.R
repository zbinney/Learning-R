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
    
    
    
    
    
    
    

    
    
    
##### DATA VIZ / GGPLOT2(R FOR DATA SCIENCE BOOK, CH. 3) #####
    
    #View MPG dataset
    mpg
    
    #GRAPH TEMPLATE. DO NOT RUN!
    #ggplot(data = <DATA>) + 
      #<GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
    
    
    #Basic scatterplots
    
      #create basic, unmodified scatterplot of displ (engine size) vs. MPG
      ggplot(data=mpg) + #Creates coordinate system to which we can add layers.
                         #Dataset being plotted is MPG
        geom_point(mapping = aes(x = displ, y = hwy)) #Add a layer of points to coordinate system.
                                                      #Specifically, "mapping" the following "aesthetics"
  
    
      
      #Modifying plot "aesthetics"
      
      #Map the scatterplot points to a COLOR by vehicle "class"
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = class))
        #Just needed to associate the aesthetic "color" with variable "class"
        #ggplot2 automatically set a color per level of "class" and added legend
      
      #Map the scatterplot points to a SIZE by vehicle "class", although it's a little weird
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, size = class))
        #Hell, ggplot2 even warns us this is a dumb idea. But it'll work
      
      #Map the scatterplot points to a TRANSPARENCY by vehicle "class"
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
      
      #Map the scatterplot points to a SHAPE by vehicle "class"
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, shape = class))
        #Maximum 6 shapes --> SUVs unplotted! Whomp whomp.
      
      #Try mapping a continuous variable to color, in our case City MPG
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = cty))
        #You get a gradation (automatically generated? So dark...)
        #Same thing happens with size, though exact category boundaries unclear
        #Can't do this with shape
      
      #Try mapping same variable (class) to multiple aesthetics
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = class, size = class))
        #Both are applied! It works!
      
      #Can also subset points with a logical aesthetic!
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = cty < 20))
        #Colors points differently depending on their city MPG!
      
      #NOTE: in all these, ggplot2 automatically chose a scale (both for axes and aesthetics)
      #Also note X and Y locations themselves are "aesthetics" --> location aesthetics
      
      #Make all scatterplot points blue
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
        #Note "color="blue"" is outside the aes parentheses! It's an argument of the
        #geom_point function, so applies to all points
      
        #Can also specify size in mm, or shape as corresponding number from Fig. 3.1 in
        #R for data science. Can also modify shape border, fill
        #Can specify range of color gradients, transparency of shape, etc...very flexible
      
      
      
      
    #Facetting
      
      #Basic scatterplot: facets (subplots) on a single variable
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy)) +
        facet_wrap(~ class, nrow = 3, labeller = "label_both")
        #NOTE: Could also graph in column with facet_grip (. ~ class)
      
      #Basic scatterplot: facets (subplots) on multiple variables
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy)) +
        facet_grid(drv ~ cyl, labeller = "label_both")
      
      
    
      
      
      
    #Geoms: different "visual objects" to represent the data - i.e. different chart types!
      #Over 30 different geoms. SEE GGPLOT2 cheatsheet.
      
      #Comparing "point" (scatterplot) geom to "smooth" (smooth line) geom
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy))
      
      ggplot(data=mpg) +
        geom_smooth(mapping = aes(x = displ, y = hwy))
        #Note: default method for fitting smooth line is LOESS
      
      #All geoms take a "mapping" argument, but not every aesthetic works with every geom
      
      #Stratified line plot
      ggplot(data=mpg) +
        geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
      
      #Overlay fitted lines on scatterplot, stratifying by color
      ggplot(data=mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = drv)) +
        geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color=drv))
        #Problem: if wanted to change x-axis, have to do so in two places. Solution?
      
      #Global (instead of local) mappings for ALL layers
      ggplot(data=mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
        geom_point() +
        geom_smooth()
      
      #Use locals mappings to apply aesthetic to only one layer
      ggplot(data=mpg, mapping = aes(x = displ, y = hwy)) +
        geom_point(mapping = aes(color = drv)) +
        geom_smooth()
      
      #Can even use locals to plot different data in different layers
      ggplot(data=mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
        geom_point() +
        geom_smooth(data = filter(mpg, drv == "4"))
        #Display line just for 4wd vehicles
      
      #Basic bar chart
      ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut))
      
      #Colored bar chart
      ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut, fill = cut))
        #Kinda pointless, but will make more sense later
        
      
    #Stats (statistical transformations): Algorithm used to create variable not in dataset
    #for plotting. "stat" for smoother is fitted model predictions; for bars/histograms,
    #counts, etc. Check help for a given geom for details.
    #Over 20 available in GGPLOT2
      
      
      #We could use the underlying stat to recreate the bar plot above!
      ggplot(data = diamonds) +
        stat_count(mapping = aes(x = cut))
        
      #Use stat explicitly 1: overriding default stat. 
      #Ex: bar chart with count already in dataset
      demo <- tribble(
        ~a,      ~b,
        "bar_1", 20,
        "bar_2", 30,
        "bar_3", 40
      )
      
      ggplot(data = demo) +
        geom_bar(mapping = aes(x = a, y = b), stat = "identity")
      
      #Use stat explicitly 2: override default mapping from transformation to aesthetic 
      #Ex: proportion in bar chart
      ggplot(data = diamonds) +
        geom_bar(mapping = aes (x = cut, y = ..prop.., group = 1))
      
      #Use stat explicitly 3: draw attention to transformation
      #Ex: plot min, median, and max depth by cut using stat_summary()
      ggplot(data = diamonds) +
        stat_summary(mapping = aes(x = cut, y = depth),
                                   fun.y = median,
                                   fun.ymin = min,
                                   fun.ymax = max)
      
      
    
      
      
    #Position adjustments
      
      #Colored, STACKED bar chart
      ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut, fill = clarity))
        #Stacked bar chart of cut, stratified and colored by clarity
        #The stacking came from a (implied) "position" argument (, position="stack")!
      
        #Alter implicit position function to "identity"
        ggplot(data = diamonds) +
          geom_bar(mapping = aes(x = cut, fill = clarity), 
                   alpha = 0.1, position = "identity")
                   #Alpha adjusts transparency so we can see the effect of position = identity
          #Silly for bar charts, but is default for scatterplots
        
        #Alter implicit position function to "fill" -> will plot proportions
        ggplot(data = diamonds) +
          geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
        
        #Alter implicit position function to "dodge" -> GROUPED bar chart
        ggplot(data = diamonds) +
          geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
        
      #Recall our basic scatterplot
      ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy))
        #Issue: 234 observations, but only 126 points b/c overlapping values
        
        #Solution? Position = "jitter" adds tiny random perturbations to better
        #show massing of points
        ggplot(data = mpg) +
          geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
        
        #Alternatively:
        ggplot(data = mpg) +
          geom_jitter(mapping = aes(x = displ, y = hwy))
        
        #Could also use geom_count which scales size of point to # observations!
        
      
        
    #Coordinate systems
        
      #Flip X and Y axes! Example of boxplot:
      ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
        geom_boxplot() + 
        coord_flip()
        #Especially useful for long/many labels
      
      
      #Polar coordinates. Unlikely to use frequently, so just copy-pasted code for reference
      bar <- ggplot(data = diamonds) + 
        geom_bar(
          mapping = aes(x = cut, fill = clarity), 
          show.legend = FALSE,
          width = 1
        ) + 
        theme(aspect.ratio = 1) +
        labs(x = NULL, y = NULL)
      
      bar + coord_flip()
      bar + coord_polar()
      
    
    #Layered GRAMMAR OF GRAPHICS template to build any plot!
    #ggplot(data = <DATA>) + 
      #<GEOM_FUNCTION>(
        #mapping = aes(<MAPPINGS>),
        #stat = <STAT>, 
        #position = <POSITION>
      #) +
      #<COORDINATE_FUNCTION> +
      #<FACET_FUNCTION>
      #The 7 parameters here uniquely define any plot you'd want to produce. SEE R4DS ch. 3.10
      
      
    
      
      
      
      
      
      
      
    
  ##### NEXT SECTION OF CODE #####