library(rvest)

# Store web url
lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")

#Scrape the website for the movie rating
rating <- lego_movie %>%
  html_nodes("strong span") %>%
  html_text() %>%
  as.numeric()
rating

cast <- lego_movie %>%
  html_nodes("#titleCast .itemprop span") %>%
  html_text()
cast

poster <- lego_movie %>%
  html_nodes("#img_primary img") %>%
  html_attr("src")
poster
