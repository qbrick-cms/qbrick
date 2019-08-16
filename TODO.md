- replacement for old qBrick since upgrading from 4.2 to 6 would be to much as
  we also need/want to get rid of:

  - carrierwave
  - bootstrap
  - bourbon

  - change the way locales are done (separate table)
  - change the way bricks are defined (database defined via json field)
  - we need to redo the UI anyways


The way forward for a progressive MVP:

- set up rspec
- installer / generator for route
- simple page model, routing, find page
- refine page index
- bricks
- see how it works in limeco, what are we missing

- migration task
