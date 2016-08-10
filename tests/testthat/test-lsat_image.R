context("lsat_image")

one <- "L8/001/003/LC80010032014272LGN00/LC80010032014272LGN00_B1.TIF"
one_ <- "LC80010032014272LGN00_B1.TIF"
two <- "L8/001/003/LC80010032014272LGN00/LC80010032014272LGN00_B10.TIF"
two_ <- "LC80010032014272LGN00_B10.TIF"

lsat_cache_delete_all()

test_that("lsat_image, works with full paths to images", {
  skip_on_cran()

  a <- lsat_image(one)

  expect_is(a, "character")
  expect_match(a, "landsat-pds")
  expect_match(a, "TIF")
})

test_that("lsat_image, works with partial paths to images", {
  skip_on_cran()

  a <- lsat_image(two_)

  expect_is(a, "character")
  expect_match(a, "landsat-pds")
  expect_match(a, "TIF")
})

test_that("lsat_image, fails well", {
  expect_error(lsat_image("asdfadf"), "Not Found")
})

# cleanup
lsat_cache_delete_all()
