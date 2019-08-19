TODO:

- set up stimulusjs
- set up tailwindcss
- set up minimal UI
- set up prettierjs
- set u stimulus reflex
- use typescript?
- basic page, brick, brick_type models
- page lookup
- page index
- page edit

DB MODEL:

- Page
  parent id

- Translation
  - page id
  - locale id (?)
  - published at
  - other timestamps
  - url

- Brick
  translation id
  parent id
  brick type
  content

- BrickType
  fields (jsonb)
  see what we need to implement like can have children etc

FEATURE IDEAS / TODOS HIHGHLEVEL

- media pool
- auth integration hook + locking of pages
- translations out of the box
- db defined bricks, expert mode can add file from folder, normal user can add
  liqudi template?
- how to define custom components? see the ones we have in limeco
- bricks always have a page ID / content id (links to page translation)

REWRITE PLAN:

- replacement for old qBrick since upgrading from 4.2 to 6 would be to much as
  we also need/want to get rid of:

  - carrierwave
  - bootstrap
  - bourbon

  - change the way locales are done (separate table)
  - change the way bricks are defined (database defined via json field)
  - we need to redo the UI anyways


The way forward for a progressive MVP:

d set up rspec
- installer / generator for route?
- simple page model, routing, find page
- refine page index
- bricks
- see how it works in limeco, what are we missing

- migration task
