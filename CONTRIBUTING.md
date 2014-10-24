# Contributing to qBrick

## Testing / Specs

There's a dummy app inside spec/dummy. Get it running by executing the following steps:

```bash
rake setup
rake start_dummy
```

### Generator Specs
The default rspec task excludes the very slow running generator specs. You can run them like so:
```
bundle exec rspec spec -t generator
```
