# Nathalie Ylenia Triches
# 12 November 2023
# File used to create data set and perform data analysis (linear regression) as 
# part of the IODS 2023 course at Helsinki Uni

# Data wrangling ####
# 1. Create "data" folder in IODS project
# 2. Read and explore learning2014 data ####
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# explore structure of data
str(lrn14) # many integer numbers, only "age", "attitude", "points" clear
           # without other information. "gender" variable is a character.

# explore dimensions of data 
dim(lrn14) # 183 observations of 60 variables

# 3. Create analysis data set #### 
# with the variables gender, age, attitude, deep (Deep approach), stra (Strategic approach), surf (Surface approach) and points 
# by combining questions in the learning2014 data 
library(dplyr)

# gender, Age and Points in data set, don't need to be changed (yet)
# Attitude needs to be divided by 10
lrn14$attitude <- lrn14$Attitude / 10
# needed: deep, stra, surf
# deep: d_sm + d_ri + d_ue -> (D03+D11+D19+D27) + (D07+D14+D22+D30) + (D06+D15+D23+D31)
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
# select the columns related to deep learning 
deep_columns <- select(lrn14, one_of(deep_questions))
# and create column 'deep' by averaging
lrn14$deep <- rowMeans(deep_columns)

# stra: st_os (Organized Studying) + st_tm (Time Management) -> (ST01+ST09+ST17+ST25) + (ST04+ST12+ST20+ST28)
strategic_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")
# select the columns related to strategic learning 
strategic_columns <- select(lrn14, one_of(strategic_questions))
# and create column 'surf' by averaging
lrn14$stra <- rowMeans(strategic_columns)

# surf: su_lp (Lack of Purpose) + su_um (Unrelated Memorising) + su_sb (Syllabus-boundness) 
# (SU02+SU10+SU18+SU26) + (SU05+SU13+SU21+SU29) + SU08+SU16+SU24+SU32
surface_questions <-c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
# select the columns related to surface learning 
surface_columns <- select(lrn14, one_of(surface_questions))
# and create column 'surf' by averaging
lrn14$surf <- rowMeans(surface_columns)

# create new data frame
learning2014 <- lrn14 %>%
  select(c("gender","Age", "attitude", "deep", "stra", "surf", "Points")) %>%
  filter(Points > 0) %>%
  rename("age" = "Age") %>%
  rename("points" = "Points")

# 4. Set working directory and save data set ####
?setwd
setwd("/home/ntriches/github_iods2023/IODS23/")
  
# save data set
# I have made bad experiences with write_csv so I am using write.table
write.table(learning2014, "/home/ntriches/github_iods2023/IODS23/data/learning2014.csv",
            row.names = FALSE, quote = FALSE, sep = ",")  

# remove created learning2024 file
rm(learning2014)
# load saved file from above
learning2014 <- read.table(file='/home/ntriches/github_iods2023/IODS23/data/learning2014.csv', header=TRUE, sep = ",")
# check if file was loaded correctly 
head(learning2014) # yes
str(learning2014)  # yes

# Analysis ####

# 1. Read and summarise file
# load saved file from above
learning2014 <- read.table(file='/home/ntriches/github_iods2023/IODS23/data/learning2014.csv', header=TRUE, sep = ",")
str(learning2014)
dim(learning2014)

# 2. Graphical overview
# show summaries of the variables in the data
# Describe and interpret the outputs, commenting on the distributions of the variables and the relationships between them
library(ggplot2)
library(GGally)

overview_plot <- learning2014 %>%
  ggpairs(mapping = aes(col = gender, alpha = 0.3),
          lower = list(combo = wrap("facethist", bins = 20)))
overview_plot

# 3. Regression model
# Choose three variables as explanatory variables: age, gender, strategic learning
# fit a regression model where exam points is the target (dependent, outcome) variable

# scatter plot of points versus gender
scatterplot_points_attitude <- learning2014 %>%
  ggplot(aes(x = attitude, y = points)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm")
scatterplot_points_attitude

# scatter plot of points versus age
scatterplot_points_age <- learning2014 %>%
  ggplot(aes(x = age, y = points)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm")
scatterplot_points_age

# scatter plot of points versus strategic learning
scatterplot_points_stra <- learning2014 %>%
  ggplot(aes(x = stra, y = points)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm")
scatterplot_points_stra

# fit linear model `y ~ x`
# y = target (outcome) variable = points
# x = explanatory variables (predictor) = age, gender, strategic learning

# create a regression model with multiple explanatory variables
lm_model_points_stra_age_attitude <- lm(points ~ stra + age + attitude, data = learning2014)
summary(lm_model_points_stra_age_attitude)

# plot Residuals vs Fitted values, Normal QQ-plot, and Residuals vs Leverage
?plot.lm
par(mfrow = c(2,2))
plot(lm_model_points_stra_age_attitude,
     which = c(1,2,5))
par(mfrow = c(1,1))
#caption = list("Residuals vs Fitted", "Normal Q-Q", "Residuals vs Leverage"))
