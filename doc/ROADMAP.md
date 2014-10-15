# Roadmap

## Backlog (no particular order)

* Image handling Features
  * Configurable Responsive Images
    - configurable image sizes
    - use picturefill.js
    - add responsive_image_tag wich handles scrset and sizes from config

  * (re-)move ImageSizeDelegator from `engine.rb`

  * Optimize images with image_optim (use gem with statically compiled binaries!)

  * Optimize uploader with piet like on sc_web

* Allow admin to edit html/css in backend without deployment

* automatic styleguide generation

* Make searchable module find bricks not just pages
  (Would get rid of after_save_callback on bricks to update fulltext of page)
  See original issue: https://github.com/screenconcept/kuhsaft/issues/227

* Make Qbrick multisite capable

* add Google Maps brick (accept url/coordinates...)

* SEO Indicator (shows how good seo fields have been filled in)

* Allow pages to be cloned with all their content into somewhere into the site-tree

* Language specific uploaders
  https://github.com/screenconcept/kuhsaft/issues/140

* Allow redirect_url on page to be deleted
  https://github.com/screenconcept/kuhsaft/issues/269

* replace shoestrap stuff with rails_admin
