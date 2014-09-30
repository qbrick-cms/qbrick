# Roadmap

## 2.5.0

  - Merge in shoestrap functionality
    - inherited resource controllers/views/model helpers
    - generators
    - clean up i18n keys from generator

  - Site Configuration Panel
    - Provide Panel for stuff like
      - Settings field for Webmaster tools Verification
        https://github.com/screenconcept/kuhsaft/issues/271
      - default page type
      - ..
    - Allow adding custom settings via key/value
    - Provide clear API for using settings in host application

To be clarified

  - Rework Models
    - Page has layouts, layouts have areas
    - Index pages, inheritance
    - older suggestions from kuhsaft:
      Bricks & Components: https://github.com/screenconcept/kuhsaft/issues/174
    - clean up Brick STI, maybe hstore for brick attributes
    - Rework locale handling / General Cleanup
      - use translation tables
      - clean up locale vs. content_locale
      - clean up translation keys
      - merge migrations
      - remove obsoleted stuff

    - Rethink configuration
      Original Issue:
      https://github.com/screenconcept/kuhsaft/issues/254

      Yaml file? Keep it in Ruby? See Comments in issue

  - Workflows and Roles
    - Ship with authentication out of the box
    - add user management panel, user roles
    - Workflow administration/more page states

  - Backend UI Improvements
    - Add label to every brick
    - collapse all other bricks temporarily when user starts
      dragging a brick (just show the label)
    - reduce size and dynamicaly resize text inputs
    - Form inputs <textarea> with consistent sizes/margins
    - Get rid of bootstrap? Foundation? Bourbon?
    - Submit all bricks with remote true

  - Provide a rock-solid installer

  - Qbrick demo instance

  - Preview Page functionality

  - Extend Qbrick::Page link dialog to allow adding anchor on current page
    Original Issue: https://github.com/screenconcept/kuhsaft/issues/225

  - Lock page when it is being edited

  - Mediapool for assets

  - Rework frontend partials handling, provide sensible defaults

  - Better 404 handling / Getting started page
    https://github.com/screenconcept/kuhsaft/issues/147

  - Mountablity on non-root paths
    https://github.com/screenconcept/kuhsaft/issues/130

  - Caching issues
    https://github.com/screenconcept/kuhsaft/issues/270

  - Split up readme / add wiki

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
