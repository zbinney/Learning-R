##### INTRO TO R COURSE (STAT 545) ######

  #Test to ensure I have R, RStudio installed correctly
  
  x <- 2*4
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