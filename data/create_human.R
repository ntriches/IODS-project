# Nathalie Ylenia Triches
# 27 November 2023
# File used to create data set and perform data analysis (week 5) as part of the IODS 2023 course at Helsinki Uni

# Data wrangling 1 ####
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


# Data wrangling 2 ####
# load saved file from above
human <- read.csv(file='/home/ntriches/github_iods2023/IODS23/data/human.csv', header=TRUE, na = "..")
# check if file was loaded correctly 
head(human) # yes
dim(human)  # yes

# 1. explore and briefly describe data set ####
str(human)     # 195 obs (rows) and 19 variables (columns)
dim(human)

# The 'human' dataset comes from the United Nations Development Programme. It uses the HDI (Human Development Index)
# to assess the development on a country according to citizen attributes, not only economic growth. 
# More information on HDI can be found here: https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
# Original data from: http://hdr.undp.org/en/content/human-development-index-hdi

# For this assignment, I renamed all original variables as shown in code lines 23- 40 above

# 2. exclude variables ####
library(dplyr)
human_excluded <- human %>%
  rename("Edu2.FM" = "Ratio.Edu2",
         "Labo.FM" = "Ratio.Labo") %>%
  select("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# 3. remove rows with missing values (NA)
human_excluded_noNA <- human_excluded %>%
  na.omit()

# 4. remove obs of regions 
regions <- c("Arab States", "East Asia and the Pacific", "Europe and Central Asia", "Latin America and the Caribbean",
             "South Asia", "Sub-Saharan Africa", "World")

human_excluded_noNA_noregions <- human_excluded_noNA %>%
  filter(!Country %in% regions)
  
# save human data in data folder
# save in data folder
library(readr)
write_csv(human_excluded_noNA_noregions, "/home/ntriches/github_iods2023/IODS23/data/human.csv")

