# Roadmap

See 3.0 PR in kuhsaft: https://github.com/screenconcept/kuhsaft/pull/250

## Backlog from Kuhsaft, no particular order

* Rethink configuration
  Original Issue:
  https://github.com/screenconcept/kuhsaft/issues/254

  Yaml file? Keep it in Ruby? See Comments in issue

* Provide a rock-solid installer

* Image handling Features
  * Configurable Responsive Images
    - configurable image sizes
    - use picturefill.js
    - add responsive_image_tag wich handles scrset and sizes from config

  * (re-)move ImageSizeDelegator from `engine.rb`

  * Optimize images with image_optim

  * Optimize uplaoder with piet like on sc_web

* Allow admin to edit html/css in backend without deployment

* automatic styleguide generation

* clean up translation keys (a lot of duplicates present)

* Backend UI Improvements
  - Add label to every brick
  - collapse all other bricks temporarily when user starts
    dragging a brick (just show the label)
  - reduce size and dynamicaly resize text inputs
  - Form inputs <textarea> with consistent sizes/margins
  - Get rid of bootstrap?
  - Submit all bricks with remote true

* Make searchable module find bricks not just pages
  (Would get rid of after_save_callback on bricks to update fulltext of page)
  See original issue: https://github.com/screenconcept/kuhsaft/issues/227

* Split up readme / add wiki

* Preview Page

* Merge in shoestrap functionality or use active_admin

* Extend Qbrick::Page link dialog to allow adding anchor on current page
  Original Issue: https://github.com/screenconcept/kuhsaft/issues/225

* Make Qbrick multisite capable

* add Google Maps brick (accept url/coordinates...)

* Lock page when it is being edited

* Qbrick demo instance

* SEO Indicator (shows how good seo fields have been filled in)

* Allow pages to be cloned with all their content into somewhere into the site-tree

* Mediapool for assets

* More states than published (workflows?)

* Rework frontend partials handling, provide sensible defaults

* Rework model/page logic:
  - Bricks & Components: https://github.com/screenconcept/kuhsaft/issues/174

* Better 404 handling / Getting started page
  https://github.com/screenconcept/kuhsaft/issues/147

* Language specific uploaders
  https://github.com/screenconcept/kuhsaft/issues/140

* Mountablity on non-root paths
  https://github.com/screenconcept/kuhsaft/issues/130

* Settings field for Webmaster tools Verification
  https://github.com/screenconcept/kuhsaft/issues/271

* Caching issues
  https://github.com/screenconcept/kuhsaft/issues/270

* Allow redirect_url on page to be deleted
  https://github.com/screenconcept/kuhsaft/issues/269

* Ship with authentication out of the box, add user management panel
