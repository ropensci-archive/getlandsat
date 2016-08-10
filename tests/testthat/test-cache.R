context("caching")

x <- "L8/001/003/LC80010032014272LGN00/LC80010032014272LGN00_B4.TIF"

base <- rappdirs::user_cache_dir("landsat-pds")

test_that("lsat_cache_delete_all works", {
  expect_silent(lsat_cache_delete_all())
})

test_that("lsat_cache_list works", {
  skip_on_cran()

  # no files
  a <- lsat_cache_list()
  expect_is(a, "character")
  expect_equal(length(a), 0)

  # add a file
  tiff(file.path(base, "L8/stuff.TIF"))
  plot(1:10)
  dev.off()

  a <- lsat_cache_list()
  expect_is(a, "character")
  expect_equal(length(a), 1)

  # fails well
  expect_error(lsat_cache_list(5), "unused argument")
})

test_that("lsat_cache_details works", {
  skip_on_cran()

  tiff(file.path(base, "L8/things.TIF"))
  plot(1:10)
  dev.off()

  # file input
  a <- lsat_cache_details(lsat_cache_list()[1])

  expect_is(a, "landsat_cache_info")
  expect_equal(length(unclass(a)), 1)
  expect_is(a[[1]]$file, "character")
  expect_is(a[[1]]$type, "character")
  expect_type(a[[1]]$size, "double")

  # no file input
  a <- lsat_cache_details()

  expect_is(a, "landsat_cache_info")
  expect_equal(length(unclass(a)), 2)
  expect_is(a[[1]]$file, "character")
  expect_is(a[[1]]$type, "character")
  expect_type(a[[1]]$size, "double")
})

test_that("lsat_cache_delete works", {
  ff <- lsat_cache_list()[1]

  expect_true(file.exists(ff))
  lsat_cache_delete(ff)
  expect_false(file.exists(ff))
})

test_that("lsat_cache_delete_all works", {
  tiff(file.path(base, "L8/a.TIF"))
  plot(1:10)
  dev.off()

  tiff(file.path(base, "L8/b.TIF"))
  plot(1:10)
  dev.off()

  gg <- lsat_cache_list()

  expect_gt(length(gg), 0)

  lsat_cache_delete_all()

  expect_equal(length(lsat_cache_list()), 0)
})
