# Using and Configuring qBrick

## Site Settings

Use Site Settings for key-value like configuration you want to provide via the
qBrick Backend.  A few default settings are already provided by qBrick at the
start and can be changed via the Settings Menu.

### Adding Settings

Add new Settings by creating new `Setting` records in the database:

```
Setting.create(key: 'some_key', value: 'optional predefined value')
```

It will be immediately available in the settings menu. We recommend adding your
settings via seeds.

### Using Settings

Settings can be used in your code by calling
`Qbrick::Setting[:key_of_your_setting]`.  This will return the value of your
setting or a blank string if it is not set or does not exist.

## qBrick Generators

See our [qBrick generators](GENERATORS.md) guide.

## Making Qbrick helpers available to your app

As defined in the rails docs, load the helpers from our isolated Qbrick engine inside your application controller:

```ruby
class ApplicationController < ActionController::Base
  helper Qbrick::Engine.helpers
end
```

## Adding sublime video

Create an initializer file in your app inside `config/initializers` and set the `sublime_video_token`:

```ruby
Rails.application.config.to_prepare do
  Qbrick::Engine.configure do
    # Get the token from the MySites section on the sublime video site
    config.sublime_video_token = '123abcd'
  end
end
```

Require the sublime javascript with the following helper:

```ruby
# in your application layout in the head section
sublime_video_include_tag
```

## Configuring custom styles for bricks

Implement the `available_display_styles` on a brick model and return an array of css classnames: `['module-big', 'module-small']`. These styles can be applied to a brick instance through the UI. In the frontend, use `to_style_class` to get the configured styles:

```haml
%my-brick{ class: brick.to_style_class }
  = brick.text # ... etc
```

After setting up display styles in specific model add your translations
for the UI dropdown. E.g. you've added display styles to the TextBrick model:

```yaml
de:
  text_brick:
    display_styles:
      style1: 'My Style 1'
      style2: 'My Style 2'
```

## Configuring Grid settings for Bricks

Include the Qbrick::Gridded Module on every Brick you want to display in a grid. Default grid options are 1 to 12 (representing columns) wich can be configured via the class method `available_grid_sizes` (should return an array of integers).
Each instance of a gridded class will have a method `gridded?` wich returns true if a column size is set.

If the Gridded Module is added to a Custom Brick, it should provide a col_count integer field with default value 0.

```ruby
add_column :your_awesome_brick, :col_count, :integer, default: 0
```

## Adding custom templates with placeholder bricks

* Save your partial in `views/qbrick/placeholder_bricks/partials/_your_partial.html.haml`
* Add translations for your partial in `config/locales/models/qbrick/placeholder_brick/locale.yml`

```yaml
de:
  your_partial: Your Partial
```

## Mixing Custom Models/Views/Controllers with Qbrick Pages

Use the custom page type:

Custom pages behave almost like redirect pages except that they can have content and meta tags like normal pages.

What can you use this for: To redirect to a custom controller that does whatever you want and still have CMS content along side it. Example usage in a host app:

In Custom Controller that page redirects to:
```ruby
  def index
    # could also be extracted into before_action
    @page = Qbrick::Page.find(session[:qbrick_referrer]) if session[:qbrick_referrer]
    @somestuff = Somestuff.new
  end
```

View:
```
= render file: 'qbrick/pages/show'
```

## Invalidating placeholder bricks containing other models on model changes

Include the TouchPlaceholders module if your model is used within a
placeholder brick and define which templates it appears in:

```ruby
class Dummy < ActiveRecord::Base
  include Qbrick::TouchPlaceholders
  placeholder_templates 'some_template', 'some_other_template'
end
```

## Adding additional content languages

If you want to translate your pages into another language, generate a new translation migration:

```bash
# translate your pages into french
rails g qbrick:translations:add fr
```
Or

```bash
# translate your pages into swiss german
rails g qbrick:translations:add de-CH
```

This creates a new migration file inside `db/migrate` of your app. Run the migration as you normally do:

```bash
rake db:migrate
```

Finally, add the new translation locale to your `available_locales` inside your apps `application.rb`:

```ruby
config.available_locales = [:en, :fr]
```
Or

```ruby
config.available_locales = [:en, 'de-CH']
```

## Adding a language switch

Add scope around routes:

```ruby
scope "(:locale)", locale: /de|en|fr/ do
  root 'qbrick/pages#show'
end
```

Set the locale in the ApplicationController in a before_action and set default url options:

```ruby
before_action :set_locale

def set_locale
  if I18n.locale_available? params[:locale]
    I18n.locale = params[:locale]
  else
    I18n.locale = I18n.default_locale
  end
end

def default_url_options(options = {})
  { locale: I18n.locale }
end
```

Add method to ApplicationHelper which redirects to homepage when current page is not translated.
Make sure to have the homepage translated in every available language.

```ruby
def localized_url(url, target_locale)
  page = Qbrick::Page.find_by_url("#{I18n.locale}/#{url}")
  I18n.with_locale target_locale do
    translated_url = page.try :url
    if translated_url.present?
      "/#{translated_url}"
    else
      root_path(locale: target_locale)
    end
  end
end

def language_link(url, locale)
  localized_url(params[:url], locale)
end
```

Add language switch to navigation:

```ruby
SimpleNavigation::Configuration.run do |navigation|
  I18n.available_locales.each do |locale|
    primary.item locale, locale.to_s.upcase, language_link(params[:url], locale), highlights_on: Proc.new { I18n.locale == locale }
  end
end
```

Make sure to render only pages which are translated and published by using `published` and `translated` scope, so pages
without translation and which are not published will not be displayed in the navigation.
Here is an example of a possible navigation:

```ruby
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'right'
    primary.selected_class = 'active'
    Qbrick::Page.find_by(slug_de: 'meta-navigation').children.published.translated.each do |page|
      primary.item page.id, page.title, page.link, class: 'contact icon'
    end

    primary.item '', 'Sprache', '#', class: 'language icon has-dropdown'do |language|
      I18n.available_locales.each do |locale|
        language.dom_class = 'dropdown'
        language.item locale, language_text(locale), language_link(params[:url], locale), highlights_on: Proc.new { I18n.locale == locale }, class: "icon lang-#{locale}"
      end
    end
  end
end
```

## Styling the content

By default, the text editor lets you add the following tags, for which you should supply some styles in your app:

    p, h1, h2, h3, h4, table, a, strong, em

## Building a navigation

Building a navigation is simple, access to the page tree is available through the common methods built into the ancestry gem.
Just make sure you are only accessing published pages for your production site, using the `published` scope.
Or if your page is translated, using the `translated` scope and the `published` scope.

### 2 level navigation example using simple-navigation

```ruby
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    # build first level
    Qbrick::Page.roots.published.translated.each do |page|
      primary.item page.id, page.title, page.link do |sub_item|
        # build second level
        page.children.published.translated.each do |subpage|
          sub_item.item subpage.id, subpage.title, subpage.link
        end
      end
    end
  end
end
```

## Use the `page_title` attribute in your app

Qbrick::Pages will provide a `%title` tag containing its `page_title`
(or the required `title`if no title is present). Simply yield for
`:head` in your `application.html` to use it.

```haml
%head
  = yield(:head)
```

## Modifying the backend navigation

Simply override the default partial for the main navigation in your app with your own file at `qbrick/cms/admin/_main_navigation.html.haml`

## Adding your own Bricks

* Create your Brick model in `app/models`, for example `CaptionBrick`, which inherits from `Qbrick::Brick`.
* If u use a string field add a max-length validation of 255 characters.
  To prevent a `ActiveRecord::StatementInvalid` Error.
* Create a migration which adds the necessary fields to the `qbrick_bricks` table.
* If your brick should be accessible via UI, add a BrickType into the seeds or add a migration:
    `Qbrick::BrickType.create(:class_name => 'CaptionBrick', :group => 'elements')`
* Add the `edit` and `show` partials to your views, e.g: `app/views/caption_bricks/caption_brick/_edit.html.haml`
* Add the `childs` partial to your views, if you want to render your bricks childs with your own html: `app/views/caption_bricks/caption_brick/_childs.html.haml`
* Implement the `fulltext` method on your brick, return anything you want to be searchable.
* Customize the edit form behaviour of your brick by overriding methods like `to_style_class?`. See the `Brick` and `BrickList` files for more methods.

### Use the Qbrick ImageBrickImageUploader for your own Brick

Qbrick has a module called `ImageUploaderMounting`. This module mounts the ImageBrickImageUploader
and includes a callback method which handles that the image sizes will be updated after save.

```ruby
class CustomBrick < Brick
  include Qbrick::ImageUploaderMounting
  ...
end
```

If you do not include this module, then the images will not be changed when selecting one of your own image
sizes. See "Configuring the image brick" for more details on creating your own image sizes.

## Integrating search

Qbrick supports fulltext search when using PostgreSQL with a simple
LIKE fallback for any other ActiveRecord DB.

Add a call to the `search_page_form` helper in your views. This renders
the default search form. The query will be executed by qbrick.

```haml
# e.g. _footer.html.haml
= search_page_form
```

To customize the search and result views you can add your own partials
to your rails app. The following partials are overridable.

    app/views/qbrick/search
    ├── _form.html.haml           # Search form
    ├── _results.html.haml        # Results list (@pages)
    └── _results_entry.html.haml  # Single result entry (@page)

When using PostgreSQL, an additional attribute `excerpt` will be
available on the page model. It includes a highlighted excerpt of the
matching `fulltext` column.

## Selecting CMS pages in CKEditor (API)

The pages API is available under `/:locale/api/pages.json`. Only the
title and url attribute is rendered in the json.

### Usage
Add the following lines to your `ck-config.js` file. The first line
disables the standard link plugin. The second line enables the adv_link
plugin, which we need for the CMS Page link dialogue in CKEditor.

```javascript
config.removePlugins = 'link'
config.extraPlugins = 'adv_link'
```

Do not forget to update your `config.assets.precompile` array. Add the
following to your existing array `ckeditor/adv_link/*`.

## Authentication

Qbrick itself does not ship with any form of authentication. However, it is fairly easy to add by plugging into the Qbrick::Cms::AdminController. An example with [devise](https://github.com/plataformatec/devise):

```ruby
# config/initializers/qbrick.rb
Rails.application.config.to_prepare do
  Qbrick::Cms::AdminController.class_eval do
    before_filter :authenticate_user!
  end
end
```

Also, be sure to have override the navigation partial in `app/views/qbrick/cms/admin/_main_navigation.html.haml` so you get a working logout button.

## Extending the backend CSS/javascript
Qbrick installs a sass file in `assets/stylesheets/qbrick/cms/customizations.css.sass` and a coffeescript file in `assets/javascripts/qbrick/cms/customizations.js.coffee` which are loaded by the backend layout. Those files can be installed by running `rails generate qbrick:assets:install`.

Make sure they are in the `config.assets.precompile` array in environments like production where you usually precompile the assets. The generator will only add the necessary configs for the production env!
