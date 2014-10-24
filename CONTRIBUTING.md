# Contributing to qBrick

## File an issue

Please check our [GitHub issue
tracker](https://github.com/screenconcept/qbrick/issues) for known issues
before opening a new one and make sure to check our
[roadmap](https://github.com/screenconcept/qbrick/wiki/Roadmap) for planned
features before adding feature requests.

You can report bugs and feature requests to [GitHub
Issues](https://github.com/screenconcept/qbrick/issues).

## Development

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.  TIP: run
* rubocop locally before pushing Make sure your patches are well tested. All
* specs must pass when run on Travis CI.  Update the README if necessary or
* provide additional documentation via a PR to the [qBrick
* wiki](https://github.com/screenconcept/qbrick/wiki).  Please do not change
* the version number.

### Testing / Specs

There's a dummy app inside spec/dummy. Get it running by executing the following steps:

```bash
rake setup
rake start_dummy
```

### Generator Specs

The default rspec task excludes the very slow running generator specs. You can
run them like so:

```
bundle exec rspec spec -t generator
```
