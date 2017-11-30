## ------------------------------------------------------------------------
# knitr::opts_chunk$set(results = "hide", echo = FALSE)

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

## ---- echo = TRUE, eval = FALSE-----------------
#  library(RPostgreSQL)
#  drv = dbDriver("PostgreSQL")
#  # everyones user name and password is different
#  # database name is the same as your user name
#  con = dbConnect(drv, user = "user.name", password = "user.password", dbname = "user.dbname")

## ---- eval = FALSE------------------------------
#  statement = "
#  CREATE TABLE fuel_economy (
#    EngDispl double precision,
#    NumCyl integer,
#    Transmission text,
#    FE double precision
#  );
#  "
#  dbExecute(con, statement)

## ---- eval = FALSE------------------------------
#  statement = "
#  INSERT INTO fuel_economy (EngDispl, NumCyl, Transmission, FE)
#    VALUES
#    (2.0, 4, 'M5', 46.4387),
#    (3.6, 6, 'S6', 40.0000),
#    (2.5, 4, 'S4', 32.9103),
#    (5.7, 8, 'A5', 26.0000),
#    (1.8, 4, 'A4', 47.2000),
#    (7.0, 6, 'A6', 36.0000);
#  "
#  dbExecute(con, statement)

## ---- eval = FALSE------------------------------
#  statement = "
#  UPDATE fuel_economy
#    SET EngDispl = 3.5
#    WHERE EngDispl = 7.0;
#  "
#  dbExecute(con, statement)

## ---- eval = FALSE------------------------------
#  statement = "
#  ALTER TABLE fuel_economy
#    ADD COLUMN gearbox text;
#  "
#  dbExecute(con, statement)

## ---- echo = TRUE, eval = FALSE-----------------
#  dbWithTransaction(
#    con,
#    {
#      dbExecute(con, "UPDATE balances SET amount = amount - 100 WHERE customer = 'Alice';")
#      dbExecute(con, "UPDATE balances SET amount = amount + 100 WHERE customer = 'Ben';")
#    }
#  )

## ---- eval = FALSE------------------------------
#  statement = "
#  BEGIN;
#  UPDATE fuel_economy
#    SET gearbox = 'manual'
#    WHERE transmission LIKE 'M%';
#  UPDATE fuel_economy
#    SET gearbox = 'sequential'
#    WHERE transmission LIKE 'S%';
#  UPDATE fuel_economy
#    SET gearbox = 'automatic'
#    WHERE transmission LIKE 'A%';
#  COMMIT;
#  "
#  dbExecute(con, statement)

## ---- echo = TRUE, eval = FALSE-----------------
#  data("FuelEconomy", package = "jRsql")

## ---- eval = FALSE------------------------------
#  colnames(cars2010) = tolower(colnames(cars2010))
#  dbWriteTable(con, name = "cars", cars2010)

## ---- eval = FALSE------------------------------
#  query = "
#  SELECT * FROM cars
#    WHERE engdispl >= 3.0;
#  "
#  df = dbGetQuery(con,query)
#  nrow(df)
#  # 695

## ---- eval = FALSE------------------------------
#  query = "
#  SELECT fe FROM cars
#    ORDER BY fe DESC
#    LIMIT 1;
#  "
#  dbGetQuery(con,query)
#  # 69.6404

## ---- eval = FALSE------------------------------
#  query = "
#  SELECT DISTINCT transmission FROM cars;
#  "
#  dbGetQuery(con,query)
#  # 16

