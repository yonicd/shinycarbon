#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION

#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname app_ui
#' @export 
#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom shiny fillRow h2 actionButton hr fileInput textInput uiOutput textAreaInput
#' @importFrom shinyAce aceEditor
#' @importFrom rstudioapi getSourceEditorContext
#' @importFrom slickR slickROutput
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    miniUI::miniPage(
      miniUI::gadgetTitleBar("Carbonate Shiny App"),
      
      miniUI::miniContentPanel(
        
        shiny::fillCol(flex = c(2,1),
          shiny::fillRow(flex = c(2,1),
            column(width = 12,
                   shiny::h2('Script'),
                  shiny::actionButton(inputId = 'get',label = 'Fetch from carbon.js'),
                  shiny::hr(),
                  shinyAce::aceEditor(
                    height = '200px',
                    outputId = "myEditor",
                    wordWrap = TRUE,
                    value = rstudioapi::getSourceEditorContext()$selection[[1]]$text,
                    mode = "r",
                    theme = "ambiance",
                    placeholder = 'Enter Code Here ...',
                    fontSize = 10
                  )),
            column(12,
                   shiny::h2('Twitter'),
                   shiny::actionButton(inputId = 'post',label = 'Post to Twitter'),
                   shiny::hr(),
                   shiny::textInput(inputId = 'reply_status_id',label = NULL,placeholder = 'Enter reply status id'),
                   shiny::uiOutput('chars'),
                   shiny::textAreaInput(
                     inputId = 'status',
                     label = sprintf('Tweet Status: Posting as @%s', 
                                     Sys.getenv('TWITTER_SCREEN_NAME'))
                   )
            )
            ),
          shiny::fillRow(
            column(width = 12,
                   shiny::hr(),
                   shiny::h2('Images'),
                   shiny::fileInput("local", NULL, accept = c("image/png")
                   ),
                   slickR::slickROutput('carbons'))
          )
        )
        
      ))
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'shinycarbon')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
