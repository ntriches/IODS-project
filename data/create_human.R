# Nathalie Ylenia Triches
# 27 November 2023
# File used to create data set and perform data analysis (week 5) as part of the IODS 2023 course at Helsinki Uni

# Data wrangling 
# 1. create R script 
# 2. read files
library(readr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# 3. explore data set ####
str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

# 4. look at meta files and rename variables with shorter names ####
hd_renamed <- hd %>%
  rename("HDI.R"    = "HDI Rank",
         "HDI"      = "Human Development Index (HDI)",
         "Life.Exp" = "Life Expectancy at Birth",
         "Edu.Exp"  = "Expected Years of Education",
         "Edu.Mean" = "Mean Years of Education",
         "GNI"      = "Gross National Income (GNI) per Capita", 
         "GNI.HDI"  = "GNI per Capita Rank Minus HDI Rank")

gii_renamed <- gii %>%
  rename("GII.R"    = "GII Rank",
         "GII"      = "Gender Inequality Index (GII)",
         "Mat.Mor"  = "Maternal Mortality Ratio",
         "Ado.Birth"= "Adolescent Birth Rate",
         "Parli.F"  = "Percent Representation in Parliament",
         "Edu2.F"   = "Population with Secondary Education (Female)",
         "Edu2.M"   = "Population with Secondary Education (Male)",
         "Labo.F"   = "Labour Force Participation Rate (Female)",
         "Labo.M"   = "Labour Force Participation Rate (Male)")

# 5. mutate "gender inequality" ####
gii_mutated <- gii_renamed %>%
  mutate("Ratio.Edu2" = Edu2.F / Edu2.M,
         "Ratio.Labo" = Labo.F / Labo.M)

# 6. join and save data sets ####
human <- merge(hd_renamed, gii_mutated)
# save in data folder
write_csv(human, "/home/ntriches/github_iods2023/IODS23/data/human.csv",
            na = "..")  
# double check if it worked
# remove created human file
rm(human)
# load saved file from above
human <- read.csv(file='/home/ntriches/github_iods2023/IODS23/data/human.csv', header=TRUE, na = "..")
# check if file was loaded correctly 
head(human) # yes
dim(human)  # yes
