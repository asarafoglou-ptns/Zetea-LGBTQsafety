install.packages("devtools")
install.packages("roxygen2")
install.packages("usethis")
library(devtools)
library(roxygen2)
library(usethis)

# 1. create the R package skeleton and choose name
devtools::create("LGBTQsafety")

#setting working directory
#setwd("C:/Users/purpl/OneDrive/Documents/RM Year 2/Programming the Next Step/LGBTQsafety")

# 2. adding a license
usethis:: use_ccby_license()

# 3. move R files with functions into R directory

# 4.1 Define which functions should be available to your users
# use "#' @export" for that, add it to your .R function file
# 4.2 Use the document() function to make the functions available
# to users
devtools::document()

# 5. Do your R functions depend on other packages?
  #I am not currently using any other packages.

# 6. build your package
# creates an installable file with ending "tar.gz"
devtools::build()

# 7. your package can now be installed (by you and others!)
rm(list = ls())
devtools::install()

library(LGBTQsafety)
sexuality_marriage_law("Colombia")
gender_change_law("Saudi Arabia")
