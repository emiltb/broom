context("lsmeans")

skip_if_not_installed("lsmeans")
library(lsmeans)

fit <- lm(sales1 ~ price1 + price2 + day + store, data = oranges)
rg <- ref.grid(fit)

marginal <- lsmeans(rg, "day")

# generate dataset with dashes
marginal_dashes <- tibble(
  y = rnorm(100),
  x = rep(c("Single", "Double-Barrelled"), 50)
) %>%
  lm(y ~ x, data = .) %>%
  lsmeans::lsmeans(., ~ x) %>%
  lsmeans::contrast(., "pairwise")

test_that("lsmeans tidier arguments", {
  check_arguments(tidy.lsmobj)
  check_arguments(tidy.ref.grid)
  check_arguments(tidy.emmGrid)  # TODO: test this more
})

test_that("tidy.lsmobj", {
  tdm <- tidy(marginal)
  tdmd <- tidy(marginal_dashes)
  tdc <- tidy(contrast(marginal, method = "pairwise"))
  
  check_tidy_output(tdm)
  check_tidy_output(tdmd)
  check_tidy_output(tdc)
  
  check_dims(tdm, 6, 6)
  check_dims(tdmd, 1, 7)
  check_dims(tdc, 15, 7)
})

test_that("ref.grid tidiers work", {
  td <- tidy(rg)
  check_tidy_output(td)
  check_dims(td, 36, 7)
})
