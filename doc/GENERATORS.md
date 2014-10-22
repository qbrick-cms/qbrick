# qbrick Generators

## Custom Model Generator

qBrick comes with a custom model generator which has basically the same syntax
as the default rails scaffold generator:

```
  bundle exec rails generate qbrick:custom_model NAME [field[:type][:index]
  field[:type][:index]] [options]
```

Consider it a minimalistic kind of rails_admin.

You can use it to scaffold a CRUD interface for managing a custom model through
the CMS Backend. The generated scaffolding uses
[inherited_resources](https://github.com/josevalim/inherited_resources) and
some custom helpers in order to minimize the amount of code needed.

When you create your first custom model, a few things are put in place in order
to make future changes easier:

* Default CRUD views
* Base Controller from which CRUD controllers can inherit from
* General CRUD Locales used througout the custom model UIs
* The Main navigation Partial from qbrick get's copied into your applicaiton so
it can be overwritten

Then, for each custom model you generate:

* The actual model including the migration is generated and extended with some
qBrick helper methods
* Routing & Controller for the generated model are added
* Translation file stubs for your available locales are created
* An entry in the main navigation is added

## Customizing a generated model

TODO: Document customizations for custom model
