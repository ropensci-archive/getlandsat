context("lsat_scenes")

test_that("lsat_scenes, n_max parameter usage", {
  skip_on_cran()

  a <- lsat_scenes(n_max = 3)

  expect_is(a, "data.frame")
  expect_is(a, "tbl_df")
  expect_is(a$entityId, "character")
  expect_is(a$acquisitionDate, "POSIXct")

  expect_equal(NROW(a), 3)
})

test_that("lsat_scenes, skip parameter usage", {
  expect_warning(lsat_scenes(n_max = 3, skip = 3),
                 "you probably don't want to use 'skip'")
})
