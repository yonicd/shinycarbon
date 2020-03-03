#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param input PARAM_DESCRIPTION
#' @param output PARAM_DESCRIPTION
#' @param session PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname app_server
#' @export 
#' @importFrom shiny observeEvent eventReactive renderUI h6 stopApp
#' @importFrom slickR renderSlickR settings slickR
#' @importFrom glue glue
#' @importFrom rtweet lookup_statuses
app_server <- function(input, output,session) {

  carb <- load_carbonate(td = file.path(tempdir(),'carbonshiny'))
  td <- carb$download_path

  td_tweet <- file.path(tempdir(),'rtweet_media')
  dir.create(td_tweet,showWarnings = FALSE)
  
  shiny::observeEvent(input$myEditor,{
    carb$code <- input$myEditor
  })
  
  shiny::observeEvent(c(input$local,input$get),{
    
    output$carbons <- slickR::renderSlickR({
      
      imgs_carbon <- list.files(td,full.names = TRUE,pattern = '^img')
      imgs_local <- list.files(td_tweet,full.names = TRUE,pattern = '^local')
      
      imgs <- c(imgs_carbon,imgs_local)
      opts <- slickR::settings(adaptiveHeight = TRUE)
      
      if(length(imgs)>1){
        opts <- slickR::settings(adaptiveHeight = TRUE, dots = TRUE)
      }
      
      slickR::slickR(imgs,slideId = 'me',width = '80%') + opts
      
    })
    
  })
  
  observeEvent(input$local,{
    inFile <- input$local
    idx <- length(list.files(td_tweet,pattern = '^local')) + 1
    if(!is.null(inFile$datapath)){
      file.copy(inFile$datapath,file.path(td_tweet,glue::glue('local_{idx}.png')))
    }
  })
  
  shiny::observeEvent(input$get,{
    
    ret <- carb$carbonate(
      file = glue::glue('img_{length(list.files(td)) + 1}.png'),
      path = td
    )
    
  })
  
  # Tweet Status + Reply
  
  reply_handles <- shiny::eventReactive(input$reply_status_id,{
    
    if(!nzchar(input$reply_status_id))
      return('')
    
    reply <- rtweet::lookup_statuses(input$reply_status_id)
    
    parse_handles(text = reply$text, name = reply$screen_name)
    
  })
  
  shiny::observeEvent(c(input$status,input$reply_status_id),{
    
    carb$tweet_status <- glue::glue('{reply_handles()} {input$status}')
    
    output$chars <- shiny::renderUI({
      shiny::h6(glue::glue('Characters: {nchar(carb$tweet_status) -1 }'))
    })
    
  })
  
  shiny::observeEvent(input$post,{
    
    carb$rtweet(media = carb$carbons,
                media_format = 'png',
                in_reply_to_status_id = input$reply_status_id)
    
  })
  
  #Close and Cleanup App
  
  shiny::observeEvent(input$cancel, {
    if(input$get>0)
      carb$stop_all()
    unlink(td,recursive = TRUE,force = TRUE)
    unlink(td_tweet,recursive = TRUE,force = TRUE)
    shiny::stopApp(invisible())
  })
  
  shiny::observeEvent(input$done, {
    if(input$get>0)
      carb$stop_all()
    unlink(td,recursive = TRUE,force = TRUE)
    unlink(td_tweet,recursive = TRUE,force = TRUE)
    shiny::stopApp(invisible())
  })
}
