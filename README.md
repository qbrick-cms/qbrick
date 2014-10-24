[![Build Status](https://travis-ci.org/screenconcept/qbrick.png)](https://travis-ci.org/screenconcept/qbrick)
[![Code Climate](https://codeclimate.com/github/screenconcept/qbrick.png)](https://codeclimate.com/github/screenconcept/qbrick)
[![Gem Version](https://badge.fury.io/rb/qbrick.png)](http://badge.fury.io/rb/qbrick)

![qBrick
logo](https://raw.githubusercontent.com/wiki/screenconcept/qbrick/logo.png)

# qBrick - The Ruby on Rails CMS you want

*Formerly known as: Kuhsaft*

**qBrick is currently undergoing rapid changes as we are ramping up for
our first official release under the new name. Until 2.5 is out, expect
things to break.**

qBrick started as a side project of the Screen Concept team as we got
tired of fiddling with unusable content management systems. By following
common rails practices and not being to opinionated, qBirck aims to be a
plug and play CMS Engine that does not stand in your way or dictates how you
have to build your Rails application, while still providing some
sensible defaults and the basic functionality you would expect form a
CMS system.

# Dependencies

* A Rails 4 application
* ImageMagick
* An ActiveRecord compatible DB

# Installation

Add it to your Gemfile:

```ruby
gem 'qbrick', '2.5.0.pre'
```

Run the following command to install it:

```console
bundle install
```

Then install the assets and the migrations and run them:

```console
rake qbrick:install:migrations
rake db:migrate
rake db:seed
rails generate qbrick:assets:install
```

Load the Qbrick assets into your app, so you have working grids, widgets etc:

```sass
# application.css.sass
@import 'qbrick/application'
```

```coffee
# application.js.coffee
//= require 'qbrick/application'
```

Also, you need to define the image sizes for the image brick or use
the defaults:

```ruby
# your_app/config/initializers/qbrick.rb
Rails.application.config.to_prepare do
  Qbrick::Engine.configure do
    config.image_sizes.build_defaults! # creates 960x540 and 320x180 sizes
  end
end
```

See "Configuring the image brick" for more details.

If you would like to use the qBrick helpers in your app, include them in
your application controller:

```ruby
class ApplicationController < ActionController::Base
  helper Qbrick::Engine.helpers
end
```

Finally, mount the qBrick engine in your routes file:

```ruby
mount Qbrick::Engine => '/'
```

# Using and Customizing qBrick
See our [wiki](https://github.com/screenconcept/qbrick/wiki)

# Roadmap
See our [roadmap](doc/ROADMAP.md)

# Contributing
See our [contributing guidelines](CONTRIBUTING.md)

# License

See the [LICENSE file](LICENSE)
