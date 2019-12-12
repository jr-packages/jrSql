#' Function for filling an empty database
#'
#' Function should only be used for setting up a database for building
#' the notes and slides
#'
#' @param args a list of arguments to pass to the database connection
#' @importFrom dplyr copy_to
#' @importFrom DBI dbConnect
#' @importFrom RPostgreSQL PostgreSQL
#' @importFrom utils data
#' @export
fill_database = function(args = list(user = "jr", pass = "jr-pass",
                                     host = "localhost", port = 5432,
                                     dbname = "test")) {
  con = DBI::dbConnect(RPostgreSQL::PostgreSQL(), host = args$host,
                       password = args$pass, port = args$port,
                       user = args$user, dbname = args$dbname)
  e = new.env()
  data(diamonds, package = "ggplot2", envir = e)
  message("Adding diamonds data to database.")
  dplyr::copy_to(con, e$diamonds, name = "diamonds",
                 overwrite = TRUE, temporary = FALSE)
  data(movies, package = "ggplot2movies", envir = e)
  message("Adding movies data to databse")
  dplyr::copy_to(con, e$movies, name = "movies",
                 overwrite = TRUE, temporary = FALSE)
}

#' Check database
#'
#' Checks whether a post gres database is accessible to the session
#'
#' @inheritParams fill_database
#' @importFrom DBI dbConnect
#' @importFrom RPostgreSQL PostgreSQL
#' @return logical TRUE if database accessible
#' @param verbose logical if TRUE should give more info on errors
#' @export
check_database_exists = function(args = list(user = "jr", pass = "jr-pass",
                                             host = "localhost", port = 5432,
                                             dbname = "test"),
                                 verbose = FALSE) {
  x = tryCatch({
    con = DBI::dbConnect(RPostgreSQL::PostgreSQL(),
                          host = args$host, password = args$pass,
                          port = args$port, user = args$user,
                          dbname = args$dbname)},
               error = function(e) {
                 e
               })
  if (inherits(x, "error")) {
    if (verbose) print(x)
    return(FALSE)
  }else{
    return(TRUE)
  }
}

#' Copy compose
#'
#' Copies the docker compose file to the local directory
#' @param target target path for compose file
#' @export
copy_compose = function(target = ".") {
  file = system.file("docker-compose.yml", package = "jrSql")
  file.copy(file, target, overwrite = TRUE)
}

#' check compose
#'
#' checks for the existence of a docker compose file
#' @param dir directory path to check
#' @export
check_compose = function(dir = ".") {
  file.exists(paste0(dir, "/docker-compose.yml"))
}

#' start database
#'
#' runs system to call docker-compose up
#'
#' @param dir location from which to call docker-compose
#' @export
start_database = function(dir = ".") {
  if (!check_compose(dir)) {
    stop("Compose file missing, run copy_compose()")
  }
  wd = setwd(dir)
  system("docker-compose up -d")
  setwd(wd)
}

#' stop database
#'
#' stops the database
#'
#' @inheritParams start_database
#' @export
stop_database = function(dir = ".") {
  if (!check_compose(dir)) {
    stop("No compose file found in this directory.")
  }
  system("docker-compose down")
}

#' setup database
#'
#' runs all steps of database set up in order using default settings
#' @export
setup_database = function() {
  message("Copying compose from package /inst")
  copy_compose()
  message("Starting the database")
  start_database()
  message("Waiting for initialisation")
  while (!check_database_exists()) {
    message(".", appendLF = FALSE)
    Sys.sleep(0.5)
  }
  message("\n", "Filling database")
  fill_database()
  message("Done")
}

#' chapter check
#'
#' A function intended to be used at the start of each chapter to
#' check whether the database is available
#' @export
chapter_check = function() {
  if (!check_database_exists()) {
    stop("Database doesn't exist, start and fill the database.")
  }
}

#' chapter connect
#'
#' A function for returning a database connection intended to
#' be used at the start of each chapter. Also checks whether the
#' database is available first.
#'
#' @inheritParams fill_database
#' @importFrom DBI dbConnect
#' @importFrom RPostgreSQL PostgreSQL
#' @return A connection object
#' @export
chapter_connect = function(args = list(user = "jr", pass = "jr-pass",
                                       host = "localhost", port = 5432,
                                       dbname = "test")) {
  chapter_check()
  con = DBI::dbConnect(RPostgreSQL::PostgreSQL(), host = args$host,
                       password = args$pass, port = args$port,
                       user = args$user, dbname = args$dbname)
  return(con)
}
