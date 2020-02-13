#' Are we on GITLAB?
#'
#' Simple utils function.
#' @export
is_gitlab = function() !is.na(Sys.getenv("GITLAB_CI", NA))
