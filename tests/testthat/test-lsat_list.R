context("lsat_list")

test_that("lsat_list works, max parameter usage", {
  skip_on_cran()

  a <- lsat_list(max = 10)
  b <- lsat_list(max = 3)

  expect_is(a, "data.frame")
  expect_is(a, "tbl_df")
  expect_is(a$Key, "character")

  expect_gt(NROW(a), NROW(b))
})

test_that("lsat_list prefix param works", {
  skip_on_cran()

  patt <- "L8/001/003/LC80010032014272LGN00/LC80010032014272LGN00"
  d <- lsat_list(prefix = patt, max = 10)

  expect_is(d, "tbl_df")
  expect_true(all(grepl(patt, d$Key)))
})

test_that("lsat_list fails well", {
  skip_on_cran()

  # bad max value
  expect_error(lsat_list(max = "asdf"), "Bad Request")

  # marker no match
  expect_is(lsat_list(marker = "asdf", max = 1), "tbl_df")

  # prefix that doesn't match
  expect_equal(NROW(lsat_list(prefix = 5)), 0)
})
