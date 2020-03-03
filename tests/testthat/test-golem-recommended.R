context("golem tests")

library(golem)

testthat::describe('something',{
  it('this',{
    testthat::expect_equal(1L+1L,2L)
  }) 
}
)

# test_that("app ui", {
#   ui <- app_ui()
#   expect_shinytaglist(ui)
# })

# test_that("app server", {
#   server <- app_server
#   expect_is(server, "function")
# })
