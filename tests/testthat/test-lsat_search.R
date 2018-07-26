context("lsat_search")

test_that("lsat_search works", {
  skip_on_cran()

  a <- lsat_search(collection = "sentinel-2", limit = 3)

  expect_is(a, "list")
  expect_named(a, c("type", "properties", "features"))
  expect_is(a$type, "character")
  expect_is(a$properties, "list")
  expect_is(a$features, "data.frame")
  expect_equal(a$type, "FeatureCollection")

  expect_gt(NROW(a$features), 2)
})

test_that("lsat_search fails well", {
  skip_on_cran()

  expect_error(lsat_search(4), "must be of class")
  expect_error(lsat_search(datetime = 4), "must be of class")
  expect_error(lsat_search(as = 5), "must be of class")
})
