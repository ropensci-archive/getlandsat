#' getlandsat - get Landsat 8 data from AWS public data sets
#'
#' \pkg{getlandsat} provides access to Landsat \url{https://landsat.usgs.gov} 8
#' metadata and images hosted on AWS S3 at
#' \url{https://aws.amazon.com/public-data-sets/landsat}. The package only
#' fetches data. It does not attempt to aid users in downstream usage.
#'
#' @importFrom readr read_csv
#' @importFrom xml2 read_html read_xml xml_find_all as_list xml_children
#' xml_name
#' @importFrom httr content write_disk GET stop_for_status
#' @name getlandsat-package
#' @aliases getlandsat
#' @docType package
#' @keywords package
#'
#' @examples \dontrun{
#' ## List scenes
#' (res <- lsat_scenes(n_max = 10))
#'
#' ## List scene files
#' lsat_scene_files(x = res$download_url[1])
#'
#' ## Get an image
#' ### Returns path to the image
#' lsat_image(x = "LC80101172015002LGN00_B5.TIF")
#'
#' ## Visualize
#' if (requireNamespace("raster")) {
#'   library("raster")
#'   x <- lsat_cache_details()[[1]]
#'   img <- raster(x$file)
#'   plot(img)
#' }
#' }
NULL
