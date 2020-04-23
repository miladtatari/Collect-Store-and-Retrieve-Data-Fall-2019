library(tidyverse)

strikes <- read_csv("BirdStrikes.csv")
### get in the habit of reviewing the output from read_csv
### it is verbose but it does give you a sense of the cleanliness of the data
### look at problems() to see the issues
### having 1032 parse errors for 99,404 rows is not bad


View(strikes)
# View the data to see the variables names and the types of values you
# have. Get a sense of the data by running basic analysis on the columns

     strikes %>% count(`Airport: Name`)
     strikes %>% count(`Aircraft: Type`)
     strikes %>% count(`Aircraft: Flight Number`)
     strikes %>% count(`Record ID`)

# We have a key for our birdstrike data
# If we did have duplicates we would want to identify the duplicate values


     duplicates <- strikes %>% count(`Record ID`) %>% filter(n > 1)


# We need to develop a transformation process for our data.
# The variable names can be shortened.
# We should remove the spaces and special characters from the variable names
strikes <- strikes %>% rename(Record_Id = `Record ID`,
              Aircraft_Type = `Aircraft: Type`,
              Aircraft_Model = `Aircraft: Make/Model`,
              Aircraft_FlightNumber = `Aircraft: Flight Number`,
              Airport = `Airport: Name`)

strikes %>% filter(Aircraft_Type == 'Helicopter') %>% select(Aircraft_Model) %>% distinct(Aircraft_Model) %>% View

strikes %>% filter(Aircraft_Type == 'Airplane') %>% select(Aircraft_Model) %>% distinct(Aircraft_Model) %>% View


# plenty more to do
# We also need to get a sense of the entities represented via these
# variables
#Let's break the data variables up into 4 different entities:
# airline, aircraft, airport and bird_strike.
# there are other solutions, please consider your own solution
# In order to do that we need to identify
# the relationships between these 4 different entities. For example:
#   A flight having a bird strike originates from a particular airport
#   An airplane having a bird strike incident is a specific aircraft type
#   An airline owns a airplane that was involved with an birdstrike incident
# In the relational model, we represent relationships by foreign keys
# what fields are in what tibbles??

# let's create the airport tibble. What are its fields?
# Do we have a primary key in the data or do we need a surrogate key?
    airport <- strikes %>% select(`Airport: Name`, `Origin State`) %>% distinct()
# Can we find another way to verify the results you just generated
      unique(strikes$`Airport: Name`)


