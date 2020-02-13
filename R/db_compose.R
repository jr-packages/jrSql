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
  fill_database(args = NULL)
  message("Done")
}

#' chapter check
