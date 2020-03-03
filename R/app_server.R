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
#' @importFrom magick image_read
app_server <- function(input, output,session) {

  carb <- load_carbonate(td = file.path(tempdir(),'carbonshiny'))
  td <- carb$download_path

  shiny::observeEvent(input$myEditor,{
    carb$code <- input$myEditor
  })
  
  shiny::observeEvent(c(input$local,input$get),{
    
    output$carbons <- slickR::renderSlickR({
      
      imgs <- list.files(td,full.names = TRUE,pattern = '^(img|local)')

      opts <- slickR::settings(adaptiveHeight = TRUE)
      
      if(length(imgs)>1){
        opts <- slickR::settings(adaptiveHeight = TRUE, dots = TRUE)
      }
      
      slickR::slickR(imgs,slideId = 'me',width = '80%') + opts
      
    })
    
  })
  
  observeEvent(input$local,{
    inFile <- input$local
    idx <- length(list.files(td,pattern = '^local')) + 1
    if(!is.null(inFile$datapath)){
      file.copy(inFile$datapath,file.path(td,glue::glue('local_{idx}.png')))
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

    if( length(list.files(td,pattern = '^local'))>0 ){
      
      local_imgs <- lapply(list.files(td,pattern = '^local',full.names = TRUE), magick::image_read)
      
      carb$carbons <- append(carb$carbons, local_imgs)
      
    }
      
    media_format <- ifelse(length(carb$carbons)>4,'gif','png')
    
    carb$rtweet(media = carb$carbons,
                media_format = media_format,
                in_reply_to_status_id = input$reply_status_id)
    
  })
  
  #Close and Cleanup App
  
  shiny::observeEvent(input$cancel, {
    if(input$get>0)
      carb$stop_all()
    unlink(td,recursive = TRUE,force = TRUE)
    shiny::stopApp(invisible())
  })
  
  shiny::observeEvent(input$done, {
    if(input$get>0)
      carb$stop_all()
    unlink(td,recursive = TRUE,force = TRUE)
    shiny::stopApp(invisible())
  })
}
