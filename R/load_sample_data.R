#' load sample data
#'
#' A function to insert the movies and diamonds data into a SQL connection
#'
#' @importFrom dplyr copy_to
#' @param con A connection to a database
#' @export
load_sample_data = function(con) {
  e = new.env()
  data(diamonds, package = "ggplot2", envir = e)
  data(movies, package = "ggplot2movies", envir = e)
  message("Adding diamonds data to database")
  dplyr::copy_to(con, e$diamonds, name = "diamonds",
                 temporary = FALSE, overwrite = TRUE)
  dplyr::copy_to(con, e$movies, name = "movies",
                 temporary = FALSE, overwrite = TRUE)
}
