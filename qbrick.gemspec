$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'qbrick/version'

Gem::Specification.new do |spec|
  spec.name        = 'qbrick'
  spec.version     = Qbrick::VERSION
  spec.authors     = ['Felipe Kaufmann']
  spec.email       = ["'felipekaufmann@gmail.com'"]
  spec.homepage    = 'https://github.com/qbrick/qbrick'
  spec.summary     = 'A lightweight CMS'
  spec.description = 'A lightweight CMS built as a Rails Engine'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile',
                   'README.md']

  spec.add_dependency 'pg'
  spec.add_dependency 'rails', '~> 6.0.0.rc2'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'webdrivers'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'byebug'
end
