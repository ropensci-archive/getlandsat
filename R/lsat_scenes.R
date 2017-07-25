lsat_scenes_path <- file.path(lsat_path(), "lsat_scenes_meta")
lsat_scenes_file <- file.path(lsat_scenes_path, "lsat_scenes.csv")

#' List Landsat scenes
#'
#' @export
#' @param extent extent vector, of the form min lon, max lon, min lat, max lat.
#' optional. requires `rgeos` and `sp` packages
#' @param ... Further args passed on to [readr::read_csv()]
#'
#' @details We use [readr::read_csv()] to read the scene list file
#' from <http://landsat-pds.s3.amazonaws.com/scene_list.gz>. See the help
#' file for [readr::read_csv()] for what parameter you can pass to modify it's
#' behavior.
#'
#' After reading the data from the web, we cache the file to disk, but remove
#' at the end of the R session.
#'
#' This is an alternative to using [lsat_list()]. This function
#' downloads the up to date compressed csv file, while [lsat_list()]
#' uses the AWS S3 API.
#'
#' @seealso [lsat_scene_files()]
#'
#' @examples \dontrun{
#' res <- lsat_scenes()
#' res
#'
#' # read only N rows
#' lsat_scenes(n_max = 10)
#'
#' # query by extent
#' lsat_scenes(extent = c(-97, -95, 25, 30))
#' }
lsat_scenes <- function(extent = NULL, ...) {
  if (!is.null(extent)) stop("still working on this feature")
  url <- "http://landsat-pds.s3.amazonaws.com/scene_list.gz"
  args <- list(...)
  if (any(names(args) %in% 'skip')) {
    warning(
      "you probably don't want to use 'skip' as that skips the table header",
      call. = FALSE
    )
  }
  if (
    length(list.files(lsat_scenes_path)) == 0 && !file.exists(lsat_scenes_file)
  ) {
    dat <- readr::read_csv(url, ...)
    dir.create(lsat_scenes_path, recursive = TRUE, showWarnings = FALSE)
    readr::write_csv(dat, path = lsat_scenes_file)
  } else {
    dat <- readr::read_csv(lsat_scenes_file, ...)
  }
  if (!is.null(extent)) {
    # LSAT data
    zz <- split(dat, rownames(dat))
    scenes <- lapply(zz, function(x) {
      tmp <- as(raster::extent(x[['min_lon']], x[['max_lon']], x[['min_lat']], x[['max_lat']]), "SpatialPolygons")
      sp::proj4string(tmp) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
      return(tmp)
    })

    # user extent input
    e <- as(raster::extent(extent), "SpatialPolygons")
    proj4string(e) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

    # calculate overlap
    bools <- vapply(scenes, function(x) rgeos::gIntersects(x, e), logical(1))

    # get data
    dat <- dat[bools, ]

    ## using sp::over
    #xxx
  }
  return(dat)
}
