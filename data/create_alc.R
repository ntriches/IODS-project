# Nathalie Ylenia Triches
# 20 November 2023
# File used to create data set and perform data analysis (logistic regression) as part of the IODS 2023 course at Helsinki Uni
# Link to data source: http://www.archive.ics.uci.edu/dataset/320/student+performance

# Data wrangling ####
# 1. Save data downloaded from link above in "data" folder in IODS project
# 2. Create R script create_alc.R
# 3. Read and explore student-mat.csv and student-por.csv data ####
math <- read.table(file='/home/ntriches/github_iods2023/IODS23/data/student-mat.csv', header=TRUE, sep = ";")
str(math) # many variables, mostly binary characters and numeric integers, but also some
          # nominal characters (Mjob, Fjob, reason, guardian)
dim(math) # 395 observations of 33 variables

por <- read.table(file='/home/ntriches/github_iods2023/IODS23/data/student-por.csv', header=TRUE, sep = ";")
str(por)  # same variables as student-mat dataset
dim(por)  # 649 observations of 33 variables

# 4. Join data sets ####
# access the dplyr package
library(dplyr)

# create vector of columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# use setdiff to get the columns with common identifiers 
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers above
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

# look at the structure and dimensions of the joined data set
glimpse(math_por) # 6 variables more than the original data sets, still same structure 
dim(math_por) # 370 observations of 39 variables 

# 5. Remove  duplicate records in the joined data set ####
alc <- select(math_por, all_of(join_cols))

for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}

# 6. Calculate average weekly alcohol consumption ####
library(ggplot2)

# create new column alc_use by adding + averaging weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# create new logical column 'high_use': TRUE for students for which 'alc_use' is greater than 2
alc <- mutate(alc, high_use = alc_use > 2)

# 7. Check and export data ####
glimpse(alc) # everything seems to be okay

# export data to local data folder 
write.table(alc, "/home/ntriches/github_iods2023/IODS23/data/alc.csv",
            row.names = FALSE, quote = FALSE, sep = ",")  

# check if it worked correctly
# remove created alc file
rm(alc)
# load saved file from above
alc <- read.table(file='/home/ntriches/github_iods2023/IODS23/data/alc.csv', header=TRUE, sep = ",")
