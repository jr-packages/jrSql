## ---- echo = FALSE-------------------------------------------------------
knitr::opts_chunk$set(results = "hide", echo = FALSE)

## -----------------------------------------------
library(knitr)
# opts_knit$set(out.format = "latex")
knit_theme$set(knit_theme$get("greyscale0"))

options(replace.assign=FALSE,width=50)

opts_chunk$set(fig.path='figure/graphics-', 
               cache.path='cache/graphics-', 
               fig.align='center', 
               dev='pdf', fig.width=5, fig.height=5, 
               fig.show='hold', cache=FALSE, par=TRUE)
knit_hooks$set(crop=hook_pdfcrop)
knitr::opts_chunk$set(eval = FALSE)

## ---- eval = FALSE------------------------------
#  install.packages("nycflights13")
#  library(nycflights13)
#  
#  ## remember to make the connection to your database first (see chapter 1)
#  dbWriteTable(con, "airlines",airlines,overwrite = TRUE, row.names = FALSE)
#  dbWriteTable(con,"airports",airports, overwrite = TRUE, row.names = FALSE)
#  dbWriteTable(con, "flights", flights, overwrite = TRUE, row.names = FALSE)
#  dbWriteTable(con, "planes", planes, overwrite = TRUE, row.names = FALSE)
#  dbWriteTable(con, "weather", weather, overwrite = TRUE, row.names = FALSE)

## -----------------------------------------------
#  library(dplyr)
#  airlines = tbl(con, "airlines")
#  airports = tbl(con, "airports")
#  flights = tbl(con,"flights")
#  planes = tbl(con, "planes")
#  weather = tbl(con, "weather")

## -----------------------------------------------
#  df = flights %>% left_join(airports, by = c("dest" = "faa"))

## -----------------------------------------------
#  df %>% show_query()

## -----------------------------------------------
#  df2 = df %>%
#    group_by(lat,lon) %>%
#    summarise(delay = mean(arr_delay))

## -----------------------------------------------
#  df3 = df2 %>%
#    filter(!is.na(lat) & !is.na(lon) & !is.na(delay))

## ---- echo = TRUE-------------------------------
#  library(leaflet) # load mapping library
#  pal = colorNumeric("YlOrRd",domain = collect(df3)$delay) # set up a colour palette
#  df3 %>%
#    left_join(airports) %>% # join to get names again
#    collect %>% # collect to pull all the data into R
#    leaflet %>% # base map
#    # add some markers for the airports
#    addCircleMarkers(~lon,~lat,color = ~pal(delay),label = ~paste0(name," : ",delay), fillOpacity = 0.8) %>%
#    addTiles # add background map

## -----------------------------------------------
#  flights %>%
#    left_join(airlines) %>%
#    group_by(name) %>%
#    summarise(delay = mean(dep_delay)) %>%
#    collect

## -----------------------------------------------
#  flights %>%
#    left_join(planes) %>%
#    group_by(manufacturer) %>%
#    summarise(n()) %>%
#    collect

## -----------------------------------------------
#  flights %>%
#    left_join(planes) %>%
#    group_by(year,month,day) %>%
#    summarise(n = sum(seats)) %>%
#    arrange(desc(n)) %>%
#    filter(!is.na(n))
#  ## december is really popular for travel

