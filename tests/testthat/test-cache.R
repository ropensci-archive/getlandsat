context("caching")

x <- "L8/001/003/LC80010032014272LGN00/LC80010032014272LGN00_B4.TIF"
imgfile <- system.file("examples/image.TIF", package = "getlandsat")
base <- rappdirs::user_cache_dir("landsat-pds")

test_that("lsat_cache_delete_all works", {
  skip_on_cran()
  skip_on_travis()

  expect_silent(lsat_cache_delete_all())
})

test_that("lsat_cache_list works", {
  skip_on_cran()
  skip_on_travis()

  # no files
  a <- lsat_cache_list()
  expect_is(a, "character")
  expect_equal(length(a), 0)

  # add a file
  file.copy(imgfile, file.path(base, "L8/stuff.TIF"))

  a <- lsat_cache_list()
  expect_is(a, "character")
  expect_equal(length(a), 1)

  # fails well
  expect_error(lsat_cache_list(5), "unused argument")
})

test_that("lsat_cache_details works", {
  skip_on_cran()
  skip_on_travis()

  # add a file
  file.copy(imgfile, file.path(base, "L8/things.TIF"))

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
  skip_on_cran()
  skip_on_travis()

  ff <- lsat_cache_list()[1]

  expect_true(file.exists(ff))
  lsat_cache_delete(ff)
  expect_false(file.exists(ff))
})

test_that("lsat_cache_delete_all works", {
  skip_on_cran()
  skip_on_travis()

  file.copy(imgfile, file.path(base, "L8/a.TIF"))
  file.copy(imgfile, file.path(base, "L8/b.TIF"))

  gg <- lsat_cache_list()

  expect_gt(length(gg), 0)

  lsat_cache_delete_all()

  expect_equal(length(lsat_cache_list()), 0)
})
