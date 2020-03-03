# Inverted versions of in, is.null and is.na
`%not_in%` <- Negate(`%in%`)

not_null <- Negate(is.null)

not_na <- Negate(is.na)

# Removes the null from a vector
drop_nulls <- function(x){
  x[!sapply(x, is.null)]
}

# If x is null, return y, otherwise return x
"%||%" <- function(x, y){
  if (is.null(x)) {
    y
  } else {
    x
  }
}
# If x is NA, return y, otherwise return x
"%|NA|%" <- function(x, y){
  if (is.na(x)) {
    y
  } else {
    x
  }
}

# typing reactiveValues is too long
rv <- shiny::reactiveValues
rvtl <- shiny::reactiveValuesToList

#' @importFrom carbonate carbon
load_carbonate <- function(td){
  
  if(!dir.exists(td))
    dir.create(td,showWarnings = FALSE)
  
  carb <- carbonate::carbon$new(silent_yml = TRUE)
  carb$download_path <- td
  
  carb
}

parse_handles <- function(text,name){
  
  handles <- trimws(
    gsub(pattern = "(@\\w+\\s)(*SKIP)(*FAIL)|.",
         replacement =  "", 
         x = text, 
         perl = TRUE)
  )
  
  handles <- strsplit(handles,'\\s')[[1]]
  
  sender <- glue::glue("@{name}")
  whoami <- glue::glue("@{Sys.getenv('TWITTER_SCREEN_NAME')}")
  
  handles <- c(sender, handles)
  handles <- setdiff(handles, whoami)
  handles <- paste0(unique(handles),collapse = ' ')
  
  if(!length(handles))
    handles <- ''
  
  handles
}