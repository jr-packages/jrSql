check_compose = function(target = ".") {
  file.exists(file.path(target, "docker-compose.yml"))
}

#' Copy compose
#'
#' Copies the docker compose file to the local directory
#' @param target target path for compose file
#' @export
copy_compose = function(target = ".") {
  message("Copying compose from package /inst...")
  file = system.file("docker-compose.yml", package = "jrSql")
  file.copy(file, target, overwrite = TRUE)
}


#' @rdname copy_compose
#' @export
start_compose = function(target = ".") {
  message("docker-compose up...")
  if (!check_compose(target)) {
    stop("Compose file missing, run copy_compose()")
  }
  wd = setwd(target)
  system("docker-compose up -d")
  setwd(wd)
}

#' @rdname copy_compose
#' @export
stop_compose = function(target = ".") {
  message("docker compose down...")
  if (!check_compose(target)) {
    stop("No compose file found in: ", target, call. = FALSE)
  }
  system2("docker-compose", args = "down")
}

# setup_compose
#' @rdname copy_compose
#' @export
setup_compose = function() {
  copy_compose()
  start_compose()
  while (!check_database_exists()) {
    message(".", appendLF = FALSE)
    Sys.sleep(0.5)
  }

  fill_database(args = NULL)
  message("\n Done")
}
