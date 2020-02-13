#' @rdname fill_database
#' @export
get_default_args = function(args = NULL) {
  if (!is.null(args)) return(args)

  list(user = Sys.getenv("POSTGRES_USER", "jr"),
       pass = Sys.getenv("POSTGRES_PASSWORD", "jr-pass"),
       host = Sys.getenv("POSTGRES_HOSTNAME", "localhost"),
       port = 5432,
       dbname = "test")
}


#' Function for filling an empty database
#'
#' Function should only be used for setting up a database for building
#' the notes and slides
#'
#' @param args a list of arguments to pass to the database connection. If NULL
#' use default args supplied by \code{get_default_args}
#' @importFrom dplyr copy_to
#' @importFrom DBI dbConnect
#' @importFrom RPostgreSQL PostgreSQL
#' @importFrom utils data
#' @export
fill_database = function(args = NULL) {
  message("\n", "Filling database")
  args = get_default_args(args)
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
  DBI::dbDisconnect(con)
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
check_database_exists = function(args = NULL, verbose = FALSE) {
  args = get_default_args(args)

  x = tryCatch({
    con = DBI::dbConnect(RPostgreSQL::PostgreSQL(),
                         host = args$host, password = args$pass,
                         port = args$port, user = args$user,
                         dbname = args$dbname)},
    error = function(e) e
  )
  if (inherits(x, "error") && verbose) {
    message(x)
  } else {
    DBI::dbDisconnect(con)
  }
  return(!inherits(x, "error"))
}

#'
#' A function intended to be used at the start of each chapter to
#' check whether the database is available
#' @inheritParams fill_database
#' @export
chapter_check = function(args) {
  if (!check_database_exists(args)) {
    stop("Database doesn't exist, start and fill the database.", call. = FALSE)
  }
  return(invisible(NULL))
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
chapter_connect = function(args = NULL) {
  args = get_default_args(args)
  if (!is_gitlab()) chapter_check(args)

  con = DBI::dbConnect(RPostgreSQL::PostgreSQL(), host = args$host,
                       password = args$pass, port = args$port,
                       user = args$user, dbname = args$dbname)
  return(con)
}
