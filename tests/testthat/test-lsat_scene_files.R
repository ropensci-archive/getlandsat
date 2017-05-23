context("lsat_scene_files")

ub <- "https://s3-us-west-2.amazonaws.com/landsat-pds/L8"
url1 <- paste0(ub, "/010/117/LC80101172015002LGN00/index.html")
url2 <- paste0(ub, "/026/039/LC80260392015002LGN00/index.html")

test_that("lsat_scene_files, n_max parameter usage", {
  skip_on_cran()

  a <- lsat_scene_files(url1)

  expect_is(a, "data.frame")
  expect_named(a, c('file', 'size'))
  expect_is(a$file, "character")
  expect_is(a$size, "character")

  b <- lsat_scene_files(url2)

  expect_is(b, "data.frame")
  expect_named(b, c('file', 'size'))
  expect_is(b$file, "character")
  expect_is(b$size, "character")
})

test_that("lsat_scene_files, fails well", {
  expect_error(lsat_scene_files("asdfadf"), "input needs to be a URL")
})

test_that("lsat_scene_files, curl options work", {
  expect_error(lsat_scene_files(url1, timeout_ms = 10),
               "Timeout was reached")
})
