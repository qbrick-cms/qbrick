# qBrick Usage

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

See our [qBrick generators](doc/GENERATORS.md) guide.
