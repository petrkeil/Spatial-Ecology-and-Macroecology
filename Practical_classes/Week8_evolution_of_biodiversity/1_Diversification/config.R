## Configuration file to automatically download the packages that we need (in the background).

## The cool thing about R Studio is that we can run stuff in the background to have more time with the console.
## One way to do it, is to use 'sourcing'.
## 
## Have a look at the 'Source' button in the top right corner of the editor. 
## There is a little arrow pointing down, if you click it, you can select "Source as background job".
## Sourcing runs whole R scripts in the background. 
## 
## We can also click the 'Background Jobs' tab on top of the console and selct 'Start Background Job', select an .R file and run it. 
## Don't forget to indicate that you want the results in your global environment afterwards.
## 
## There is an R package that does the Job assignment (which we are using here so that everyone is doing the same)



## All packages we will need (I know it's a lot! sorry!)
package_list <-
  c(
    # Data handling
    "here",
    "dplyr",
    "ggplot2",
    
    # Phylo packages
    "ape",
    "geiger",
    "phytools",
    "picante",
    #"phangorn", # for mcc computation (not needed)
    "phylobase",
    "adephylo",
    
    # Spatial packages
    "terra",
    "sf",
    "tmap",
    "viridis",
    "gen3sis",
    "RColorBrewer"
  )


## Install packages
installed_packages <- package_list %in% rownames(installed.packages())

# Install packages not yet installed:
if (any(installed_packages == FALSE)) {
  install.packages(package_list[!installed_packages])
}

# Packages loading
invisible(lapply(package_list, library, character.only = TRUE))

## Test if everything worked :-) 
if (
  isTRUE(
    all(
      package_list %in%
      as.data.frame(
        utils::installed.packages()
      )[, 1]
    )
  )
) {
  cat("Everything is good to go")
} else {
  warning("All required packages are not installed")
  warning(
    paste(
      "Please install the following packages:",
      paste(
        setdiff(
          package_list,
          as.data.frame(
            utils::installed.packages()
          )[, 1]
        ),
        collapse = ", "
      )
    )
  )
}