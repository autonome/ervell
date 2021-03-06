# Split Test

To start a test, add your configuration to the `running_tests.coffee` file:

```coffeescript
header_design:
  key: 'header_design'
  outcomes:
    old: 8
    new: 2
  edge: 'new' # Optional
  dimension: 'dimension1' # Optional
  scope: 'local' # Optional
```

## Options

`key` name of your test

`outcomes` a hash of your outcomes. Point values must add up to one (you can also use fractions here).

`edge` is the feature that you want logged in admins to always have.

`dimension` is a Google Analytics dimension. You can create one by logging into GA, clicking 'Admin', clicking 'Custom Definitions' in the middle column, clicking 'Custom Dimensions'. From there you can create a new custom dimension. Note that you should then name this 'dimension1', 'dimesion2', etc. - corresponding to the index of the custom definition in this UI.

`scope` in some cases you may only want to initialize a test once a certain action is triggered (ie: landing on a specific page), if that's the case passing `scope: 'local'` will not globally intialize the test.

Tests are by default initialized globally meaning as soon as there is a configuration in the running tests file you'll get access to a Sharify variable the same name as your configuration key with the outcome and the test will set itself up client-side.

## Getting the outcome of a split test on the server

By default, this component sets an `sd` variable with the uppercase key of your test. If the key of your test is `artist_view_test`, `sd.ARTIST_VIEW_TEST` will contain the outcome of the split test.

## Manually initializing a test on the client-side (optional)

```coffeescript
splitTest = require '../../../components/split_test/index.coffee'
# Call the required fn with the key to your configuration
test = splitTest('header_design')
# You can then call outcome (as many times as you like, you will get the same outcome for the same user)
test.outcome() # => 'new'
# Do something with your outcome
# Another useful method is `cssClass` which will output a class name for use in stylesheets
test.cssClass() # => 'is-splittest-header_design--new'

```

## Forcing a test down a specific path (optional)

### Client-side

```coffeescript
splitTest = require '../../../components/split_test/index.coffee'
test = splitTest 'header_design'
test.set 'old' # Force down 'old' path
```

### Server-side

```coffeescript
SplitTest = require '../../components/split_test/server_split_test'
runningTests = require '../../components/split_test/running_tests'
testConfig = runningTests.header_design
test = new SplitTest req, res, testConfig
test.set 'old'
res.locals.sd[testConfig.key.toUpperCase()] = 'old' # manually set the Sharify variable
```
