# Nathalie Ylenia Triches
# 11 December 2023
# File used to create data set and perform analysis (of longitudinal data) as 
# part of the IODS 2023 course at Helsinki Uni

# Data wrangling ####
# 1. Load data sets ####
library(dplyr)
library(tidyr)
# BPRS (brief psychiatric rating scale) data = 40 males in two different treatment groups,
# rated on the BPRS before treatment (week 0) and then at weekly intervals for 8 weeks. 
# The BPRS assesses the level of 18 symptom constructs such as hostility, suspiciousness, hallucinations and grandiosity; 
# each of these is rated from one (not present) to seven (extremely severe)
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
str(BPRS) 
head(BPRS)
summary(BPRS)
# 40 obs of 11 variables. Treatment, subject and all weeks are columns with integer numbers, whereby the numbers are very similar for the weeks.

# RATS data
# Groups of rats put on different diets, and each rat's body weight (grams) was recorded repeatedly (approximately) weekly, 
# except in week seven when two recordings were taken) over a 9-week period. 
# The question of most interest is whether the growth profiles of the three groups differ.
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')
str(RATS)
head(RATS)
summary(RATS)
# 16 obs of 13 variables. ID, Group, and WD (weight) are columns with integer numbers, whereby numbers are very similar for WDs.

# 2. Convert categorical variables to factors ####
# BPRS: factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
# RATS: factor Id and group 
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# 3. Convert BPRS and RATS from wide to long form ####
# convert BPRS to long form and add week variable
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  mutate(week = as.integer(substr(weeks, 5, 5))) %>%
  arrange(weeks) # order by weeks variable

# convert RATS to long form and add time variable
RATSL <- pivot_longer(RATS, cols=-c(ID,Group), names_to = "WD",values_to = "Weight")  %>%  
  mutate(Time = as.integer(substr(WD,3,4))) %>% 
  arrange(Time) 

# 4. Compare wide to long format ####
library(ggplot2)
str(BPRSL) # treatment and subject are now factors, brps and week integer numbers
dim(BPRSL) # 360 obs of 5 variables
summary(BPRSL)

# with the data in the long format, it is now possible to compare the males in treatment group 1 and 2
# and their BPRS rating over the 8-week treatment period
# We changed the data frame from 40 obs to 360 obs

# RATS 
str(RATSL) # ID and Group are now factors, weight and time integer numbers
dim(RATSL) # 176 obs of 5 variables
summary(RATSL)

# with the data in the long format, it is now possible to compare the weight of the three rat groups over time
# We changed the data frame from 16 obs to 176 obs

# 5. Write out data sets ####
library(readr)
# save BPRSL as .csv
write_csv(BPRSL, "/home/ntriches/github_iods2023/IODS23/data/bprs.csv")  
# save RATSL as .csv
write_csv(RATSL, "/home/ntriches/github_iods2023/IODS23/data/rats.csv")  


