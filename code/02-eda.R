#load libraries using pacman
#install.packages("pacman")
#devtools::install_github('mikldk/pichor')
pacman::p_load(tidyverse, skimr, corrplot, ggplot2, GGally, knitr)

billie <- read.csv("data/af.csv") #read audio features data

str(billie) #first glimpse on variables
skim(billie) #simple statistics
summary(billie) #simple statistics


billie %>%
  count(key_name, name = "frequency", sort = TRUE) %>%
  mutate(percentage = prop.table(frequency) * 100) %>%
  mutate(percentage = round(percentage, 1)) %>%
  kable() #library knitr


billie %>% 
  count(key_name, name = "frequency") %>% 
  ggplot(aes(x = key_name, y = frequency)) +
  geom_bar(stat = "identity") +
  labs(title = "Frequency of Key Names in Billie's Songs",
       x = "Key Name",
       y = "Frequency")

#exploring modes
billie %>%
  count(mode_name, name = "frequency", sort = TRUE) %>%
  mutate(percentage = prop.table(frequency) * 100) %>%
  mutate(percentage = round(percentage, 1)) %>%
  kable() #library knitr

#exploring keys
billie %>%
  count(key_mode, name = "frequency", sort = TRUE) %>%
  mutate(percentage = prop.table(frequency) * 100) %>%
  mutate(percentage = round(percentage, 1)) %>%
  kable() #library knitr


billie %>% 
  count(key_mode, name = "frequency") %>% 
  ggplot(aes(x = key_mode, y = frequency)) +
  geom_bar(stat = "identity") +
  labs(title = "Frequency of Key Names in Billie's Songs",
       x = "Key Name",
       y = "Frequency")

#explore correlations
#plot the data to check for unusual features (particularly outliers and skewness)
pairs(af[, -c(3, 5, 12, 14:19)], pch = 20, lower.panel = NULL) #focus on scores
#exclude categorical 3, 5, 12 and 14:19 
#scatter plots reveal several outliers - these songs probably have an interesting story to tell 
#there also seem to be linear relationships between many pairs of variables

#lets refine the graph
#Coloring plots by Class helps identify potential outliers
ggpairs(af[, -c(3, 5, 12, 14:19)], ggplot2::aes(colour = factor(af$mode_napme))) #using ggplot2 and GGally

#looking more closely into correlations
m <- cor(af[, -c(3, 5, 12, 14:19)]);corrplot(m, method = "number", type = "upper", diag = F) #calculate correlation matrix and plot correlogram

testRes = cor.mtest(af[, -c(3, 5, 12, 14:19)], conf.level = 0.95)
corrplot(m, method = "number", type = "upper", p.mat = testRes, diag = F) #calculate correlation matrix and plot correlogram


#### To be added ####

#identify outliers
#outlier <- identify(cbind(train$Nscore, train$Cscore))
#probably do this with box plots 
#check: https://stackoverflow.com/questions/33524669/labeling-outliers-of-boxplots-in-r
#useful link: https://help.spotontrack.com/article/what-do-the-audio-features-mean
#useful link on emotional valence: https://web.archive.org/web/20170422195736/http://blog.echonest.com/post/66097438564/plotting-musics-emotional-valence-1950-2013

#looking into correlations
m <- cor(af[, -c(3, 5, 12, 14:19)]);corrplot(m, method = "number", type = "upper", diag = F) #calculate correlation matrix and plot correlogram
#strong positive correlation between:
#strong negative correlation between:
#positive correlations in the weak and moderate range:
#negative correlations in the weak and moderate range:
#answer the following:
#this suggest that there is some degree of redundancy in the information between the variables
#and therefore, some dimension reduction might be possible

#looking into variances
round(diag(var(af[, -c(3, 5, 12, 14:19)])), 2) #variances

#The following comments are from the ml-drug-use project. Check whether they apply here.

#variances are fairly similar across all variables
#if we were to perform some dimensional reduction (PCA), we could proceed using the variances

#That is because PCA can be sensitive to scale differences in the variables, 
#e.g. variables with high variance compared to the others, will be over-represented in the PCA 

#Therefore, when the variables are measured in different units or the variances are very
#different over different variables, it is wise to perform PCA on the correlation matrix rather than the covariance matrix.
#This is equivalent to standardizing the variables.

#In this case all variables use the same unit (standardized) - need to double check in the original paper?