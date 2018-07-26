#' Search Landsat images via the sat-api
#'
#' @export
#' @param collection (character) collection name
#' @param datetime (character) one or two dates. if one date, it's treated 
#' as a single point date time. if two dates, its treated as a date 
#' period
#' @param cloud_cover (integer) cloud cover number
#' @param sun_azimuth (numeric) sun azimuth number
#' @param sun_elevation (numeric) sun elevation number
#' @param path (integer) path
#' @param row (integer) row
#' @param limit (integer) limit number of results. default: 10
#' @param page (integer) page number to return. default: 1
#' @param as (character) if `df` we parse from JSON 
#' to an R list with data.frame's where possible. if 'list' then an R list; 
#' if `json` we give you back the JSON as character
#' @param ... curl args passed on to [crul::HttpClient()]
#'
#' @references <https://github.com/sat-utils/sat-api>
#' 
#' @return an R list with data.fraem's if `as=df`; an R list w/o attempting to 
#' parse to data.frame's where possible; otherwise JSON as character
#'
#' @examples \dontrun{
#' # collection input
#' lsat_search(collection = "sentinel-2")
#' lsat_search(collection = "landsat-8")
#' 
#' # dates
#' lsat_search(datetime = "2017-08")
#' z <- lsat_search(datetime = c("2016-12-31", "2017-01-01"))
#' z
#' 
#' # cloud cover
#' lsat_search(collection = "landsat-8", cloud_cover = 0)
#' lsat_search(collection = "landsat-8", cloud_cover = c(0, 20))
#' 
#' # sun azimuth
#' lsat_search(sun_azimuth = 162)
#' 
#' # row/path
#' lsat_search(row = 31, path = 128)
#' 
#' # pagination
#' lsat_search(limit = 0)
#' lsat_search(limit = 1)
#' lsat_search(limit = 3, page = 2)
#' 
#' # parsed to list, or not gives json
#' lsat_search(datetime = "2017-08", limit = 3, as = 'df')
#' lsat_search(datetime = "2017-08", limit = 3, as = 'list')
#' lsat_search(datetime = "2017-08", limit = 3, as = 'json')
#' 
#' # curl options
#' lsat_search(verbose = TRUE)
#' }
lsat_search <- function(collection = NULL, datetime = NULL, 
  cloud_cover = NULL, sun_azimuth = NULL, sun_elevation = NULL, 
  row = NULL, path = NULL, limit = 10, page = 1, as = 'df', ...) {
  
  assert(collection, "character")
  assert(datetime, "character")
  assert(cloud_cover, c("integer", "numeric"))
  assert(sun_azimuth, "numeric")
  assert(sun_elevation, "numeric")
  assert(row, c("integer", "numeric"))
  assert(path, c("integer", "numeric"))
  assert(limit, c("integer", "numeric"))
  assert(page, c("integer", "numeric"))
  assert(as, "character")
  stopifnot(as %in% c('df', 'list', 'json'))

  args <- tc(list(collection = collection, datetime = cm(datetime), 
    `eo:cloud_cover` = cm(cloud_cover), `eo:sun_azimuth` = cm(sun_azimuth),
    `eo:sun_elevation` = cm(sun_elevation), `landsat:row` = cm(row),
    `landsat:path` = cm(path), limit = limit, page = page))
  tmp <- lsat_GET(satapi_base(), args, ...)
  txt <- tmp$parse("UTF-8")
  if (as == "json") return(txt) 
  jsonlite::fromJSON(txt, as == "df")
}

satapi_base <- function() "https://sat-api.developmentseed.org/search/stac"

cm <- function(x) {
  if (is.null(x)) return(NULL)
  if (length(x) > 1) paste0(x, collapse = "/") else x
}
