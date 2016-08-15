#' Manage cached files
#'
#' @export
#' @name lsat_cache
#' @param files (character) one or more complete file names
#' @param force (logical) Should files be force deleted? Default: \code{TRUE}
#'
#' @details \code{cache_delete} only accepts 1 file name, while \code{cache_delete_all}
#' doesn't accept any names, but deletes all files. For deleting many specific files,
#' use \code{cache_delete} in a \code{\link{lapply}} type call
#'
#' @details We cache using \code{\link[rappdirs]{user_cache_dir}}, find your cache
#' folder by executing \code{rappdirs::user_cache_dir("landsat-pds")}
#'
#' @section Functions:
#' \itemize{
#'  \item \code{lsat_cache_list()} returns a character vector of full path file names
#'  \item \code{lsat_cache_delete()} deletes one or more files, returns nothing
#'  \item \code{lsat_cache_delete_all()} delete all files, returns nothing
#'  \item \code{lsat_cache_details()} prints file name and file size for each file,
#'  supply with one or more files, or no files (and get details for all available)
#' }
#'
#' @examples \dontrun{
#' # list files in cache
#' lsat_cache_list()
#'
#' # List info for single files
#' lsat_cache_details(files = lsat_cache_list()[1])
#' lsat_cache_details(files = lsat_cache_list()[2])
#'
#' # List info for all files
#' lsat_cache_details()
#'
#' # delete files by name in cache
#' # lsat_cache_delete(files = lsat_cache_list()[1])
#'
#' # delete all files in cache
#' # lsat_cache_delete_all()
#' }

#' @export
#' @rdname lsat_cache
lsat_cache_list <- function() {
  list.files(lsat_path(), pattern = ".TIF", ignore.case = TRUE,
             recursive = TRUE, full.names = TRUE)
}

#' @export
#' @rdname lsat_cache
lsat_cache_delete <- function(files, force = TRUE) {
  if (!all(file.exists(files))) {
    stop("These files don't exist or can't be found: \n",
         strwrap(files[!file.exists(files)], indent = 5), call. = FALSE)
  }
  unlink(files, force = force, recursive = TRUE)
}

#' @export
#' @rdname lsat_cache
lsat_cache_delete_all <- function(force = TRUE) {
  files <- list.files(lsat_path(), pattern = ".TIF", ignore.case = TRUE,
                      full.names = TRUE, recursive = TRUE)
  unlink(files, force = force, recursive = TRUE)
}

#' @export
#' @rdname lsat_cache
lsat_cache_details <- function(files = NULL) {
  if (is.null(files)) {
    files <- list.files(lsat_path(), pattern = ".TIF", ignore.case = TRUE,
                        full.names = TRUE, recursive = TRUE)
    structure(lapply(files, file_info_), class = "landsat_cache_info")
  } else {
    structure(lapply(files, file_info_), class = "landsat_cache_info")
  }
}

file_info_ <- function(x) {
  fs <- file.size(x)
  list(file = x,
       type = "tif",
       size = if (!is.na(fs)) getsize(fs) else NA
  )
}

getsize <- function(x) {
  round(x/10 ^ 6, 3)
}

#' @export
print.rerddap_cache <- function(x, ...) {
  cat("<rerddap cached files>", sep = "\n")
  cat(" NetCDF files: ", strwrap(x$nc, indent = 5), sep = "\n")
  cat(" CSV files: ", strwrap(x$csv, indent = 5), sep = "\n")
}

#' @export
print.landsat_cache_info <- function(x, ...) {
  cat("<landsat cached files>", sep = "\n")
  cat(sprintf("  directory: %s\n", lsat_path()), sep = "\n")
  for (i in seq_along(x)) {
    cat(paste0("  file: ", sub(lsat_path(), "", x[[i]]$file)), sep = "\n")
    cat(paste0("  size: ", x[[i]]$size, " mb"), sep = "\n")
    cat("\n")
  }
}

lsat_path <- function() rappdirs::user_cache_dir("landsat-pds")
