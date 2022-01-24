library(tidyverse) 
library(rjson)


airbnb_data <- read.csv("airbnb-listings.csv", sep = ';', encoding = "UTF-8")

grouped_airbnb_host <- airbnb_data %>%
  group_by(Host.ID) %>%
  summarize(
    Number.of.Listings = n(),
    Mean.Price = mean(Price, na.rm = TRUE),
    Mean.Review.Scores.Rating = mean(Review.Scores.Rating, na.rm = TRUE),
    Mean.Review.Scores.Accuracy = mean(Review.Scores.Accuracy, na.rm = TRUE),
    Mean.Review.Scores.Cleanliness = mean(Review.Scores.Cleanliness, na.rm = TRUE),
    Mean.Review.Scores.Checkin = mean(Review.Scores.Checkin, na.rm = TRUE),
    Mean.Review.Scores.Communication = mean(Review.Scores.Communication, na.rm = TRUE),
    Mean.Review.Scores.Location = mean(Review.Scores.Location, na.rm = TRUE),
    Mean.Review.Scores.Value = mean(Review.Scores.Value, na.rm = TRUE),
    Mean.Number.of.Reviews = mean(Number.of.Reviews, na.rm = TRUE),
    Host.Name = Host.Name, 
    Host.Since = Host.Since,
    Host.Response.Rate = Host.Response.Rate,
    Host.Response.Time = Host.Response.Time,
    Host.Acceptance.Rate = Host.Acceptance.Rate
  ) 


grouped_airbnb <- airbnb_data %>%
  group_by(Neighbourhood.Group.Cleansed) %>%
  summarize(
    Mean.Price = mean(Price, na.rm = TRUE),
    Mean.Review.Scores.Rating = mean(Review.Scores.Rating, na.rm = TRUE),
    Mean.Host.Response.Rate = mean(Host.Response.Rate, na.rm = TRUE),
    Mean.Accomodates = mean(Accommodates, na.rm = TRUE),
    Mean.Bathrooms = mean(Bathrooms, na.rm = TRUE),
    Mean.Bedrooms = mean(Bedrooms, na.rm = TRUE),
    Mean.Beds = mean(Beds, na.rm = TRUE),
    Number.of.Listings = n()
  )
