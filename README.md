
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shinycarbon

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `shinycarbon` is to create a shiny wrapper to make it easy
to share {carbonate} images on twitter.

## Installation

You can install using:

``` r
remotes::install_github("yonicd/shinycarbon")
```

## Loading the App

``` r
library(shinycarbon)
```

There are two ways to load the app

Command line

``` r
shinycarbon::run_app()
```

Addin

<img src="inst/addin.png" width="100%" />

## Preloading Script

If you are in RStudio you can pre-load the app with script by
highlighting text and running the addin.

## Layout

The basic app layout is pretty straight forward:

  - Top right is a `shinyAce` editor to put in the code you want to send
    to `carbon.js` using the button above it.
  - Bottom right is where the images come out to preview them in a
    `slickR` carousel.
      - Remember only 4 images per tweet, more images will automatically
        be converted into a gif
  - Bottom left is a button to import images from you local machine into
    the carousel
      - Handy for capture screen and what not…
  - Top left is where you construct your tweet for `rtweet`.
      - The app uses the System Variable ‘TWITTER\_SCREEN\_NAME’ as the
        tweeting handle.
      - You can reply to tweet by inserting the tweet id into the ‘enter
        reply status id’ field
      - Write your post into the text area, don’t worry about handles
        for a reply that is taken care for you under the hood.
      - Your character count is shown above the text area for
        convenience. If there are reply handles that are added the
        character count will take them into account.

Here is a screenshot:

<img src="inst/app.png" width="100%" />
