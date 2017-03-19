# dt-picker-ng-comp
Angular 1.5 DateTimePicker Component

## Installation

```shell
bower install  https://github.com/DScheglov/dt-picker-ng-comp.git
```

## Linking to the project:

**Inject Scripts and Styles**:
```html
<!-- moment.js will be installed with dt-picker-ng-comp as dependency -->
<script src="bower_components/moment/moment.js"></script>
<!-- or other locale file -->
<script src="bower_components/moment/locale/ru.js"></script>

<script src="bower_components/dt-picker-ng-comp/index.js"></script>
<link rel="stylesheet" href="bower_components/dt-picker-ng-comp/styles.css"/>
```

**Inject module dependency in your module declaration**
```javascript
// your index.js

angular
  .module('app', ['dateTimePickerNgComponent'])
  .controller('main', function () {
    var $ctrl = this;
    $ctrl.date = new Date(2014, 8, 8);
    $ctrl.update = function(value) {
      $ctrl.date = value;
    }
  } )
```

**Place component tag in the your html**
```html

<body ng-app="app" ng-controller="main as $ctrl">
....
<date-time-picker
  cancel-text="'Reset'"
  value="$ctrl.date"
  always-visible="true"
  on-change="$ctrl.update"
  ></date-time-picker>
...
</body>
```


## Configuration

`DateTimePicker` supports following parameters:
 - value (value): `Date` - one-way link to your model (or just provide constant)
 - dateFormat (date-format): `String` -- **moment.js** date format (w/o time)
 - minuteStep (minute-step): `Number` -- the step for minutes picker (5 by default)
 - cancelText (cencel-text): `String` -- the text to be placed on the cancel button
 - acceptText (accept-text): `String` -- the text to be placed on the accept button (however to use text longer then 2 chars will require to update stylesheet)
 - visible (visible): `Boolean` -- the one-way link to manage visibility state of the component
 - alwaysVisible (always-visible): `Boolean` -- the way to prevent closing the picker when Accept or Cancel button pressed
 - onOpen (on-open): `Function` -- the hook that will be called when picker is shown. The first parameter is instance of DateTimePicker
 - onHide: (on-hide): `Function` -- the hook that will be called when picker became hidden. The parameter is the same as for `onOpen`
 - onChange: (on-change): `Function` -- the hook that will be called when acceptButton is pressed


## Development

```shell
git clone https://github.com/DScheglov/dt-picker-ng-comp.git
cd dt-picker-ng-comp && npm install
npm run build
```

## TODO:
 - [ ] write tests
 - [ ] create linking directive (dt-picker)
