#Set and check a new working directory (Dropbox so we can shift between computers)
setwd("C:/Users/zbinney/Dropbox/Learning R/STAT545")
getwd()

#Create some data for a simple scatterplot with trend line
a <- 2
b <- -3
sig_sq <- 2.0
x <- runif(40)
y <- a + b * x + rnorm(40, sd = sqrt(sig_sq))
(avg_x <- mean(x))

#Print the two 40-observation objects you just created
x
y

#Print the mean of X to a .txt file
write(avg_x, "avg_x.txt")

#Create a scatterplot with trendline of X and Y
plot(x, y)
abline(a, b, col = "purple")

#Print scatterplot to external PDF file
dev.print(pdf, "toy_line_plot.pdf")
