#Get gapminder data
install.packages("gapminder")
library(gapminder)

#Check structure of Gapminder data
str(gapminder)

#Install tidyverse
install.packages("tidyverse")
library(tidyverse)

#Now that tidyverse - and by extension tibbles - are loaded, let's print Gapminder
class(gapminder)
gapminder

  #Gapminder was a tibble, but if it weren't...
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
