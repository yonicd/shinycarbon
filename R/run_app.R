#' @title Run the Shiny Application
#' @description FUNCTION_DESCRIPTION
#' @param ... PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[golem]{with_golem_options}}
#'  \code{\link[shiny]{shinyApp}}
#' @rdname run_app
#' @export 
#' @importFrom golem with_golem_options
#' @importFrom shiny shinyApp
run_app <- function(...) {
  
  on.exit({
    unlink(file.path(tempdir(),'carbonshiny'),recursive = TRUE,force = TRUE)
  },add = TRUE)
  
  golem::with_golem_options(
    app = shiny::shinyApp(ui = app_ui, server = app_server), 
    golem_opts = list(...)
  )

}
