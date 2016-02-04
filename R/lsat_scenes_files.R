#' List files for a Landsat scene
#'
#' @export
#' @param x (character) A URL to a scene html file
#' @param ... Further args passed on to \code{\link[aws.s3]{getobject}}
#' @examples \dontrun{
#' res <- lsat_scenes(n_max = 10)
#' lsat_scene_files(x = res$download_url[1])
#' lsat_scene_files(x = res$download_url[2])
#' }
lsat_scene_files <- function(x, ...) {
  path <- strextract(x, "L8.+")
  tmp <- aws.s3::getobject("landsat-pds", path, ...)
  txt <- httr::content(tmp, "text", encoding = "UTF-8")
  html <- xml2::read_html(txt)
  df <- do.call("rbind.data.frame", lapply(xml2::xml_find_all(html, '//li'), function(x) {
    al <- xml2::as_list(x)
    size <- strextract(strextract(al[[2]], "\\(.+"), "[0-9\\.]+[A-Z]+")
    list(file = al$a[[1]], size = size)
  }))
  colClasses(df, "character")
}
