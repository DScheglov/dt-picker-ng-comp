
class DtPickerInputPanel

  @controller: @
  @inject: [ 'moment' ]

  @bindings:
    value: '<'
    dateFormat: '<'
    onUpdate: '<'
    minuteStep: '<'

  @template: """
    <div class="dt-picker-input-panel">
      <div class="dt-date-input-group">
        <select ng-model="$ctrl.date"
                ng-change="$ctrl.change(\'Date\')"
                ng-options="d for d in $ctrl.days track by d">
        </select>
        <span class="separator"></span>
        <select ng-model="$ctrl.month"
                ng-change="$ctrl.change(\'Month\')"
                ng-options="m for m in $ctrl.months track by m">
        </select>
        <span class="separator"></span>
        <input ng-model="$ctrl.fullyear" ng-change="$ctrl.change(\'FullYear\')">
      </div>
      <div class="dt-time-input-group">
        <select ng-model="$ctrl.hours"
                ng-change="$ctrl.change(\'Hours\')"
                ng-options="h for h in $ctrl.allHours track by h">
        </select>
        <span class="separator"></span>
        <select ng-model="$ctrl.minutes"
                ng-change="$ctrl.change(\'Minutes\')"
                ng-options="m for m in $ctrl.allMinutes track by m">
      </div>
    </div>
  """

  constructor: (moment) ->
    @_moment = moment
    @allHours = ( i for i in [0..23] )

  $onChanges: () -> @$onInit()

  $onInit: () ->
    dummy = () ->
    @onUpdate = dummy if typeof(@onUpdate) isnt 'function'
    @moment = @_moment @value
    @months = @getMonths /M+/.exec(@dateFormat)[0]
    @minuteStep = @minuteStep || 5
    minsCount = 60 / @minuteStep
    if (m = parseInt(minsCount)) < minsCount
      minsCount = m
    else
      minsCount = m - 1
    @allMinutes = (i * @minuteStep for i in [0..minsCount])
    @days = @getDays()
    @date = @value.getDate()
    @month = @months[@value.getMonth()]
    @fullyear = @value.getFullYear()
    @hours = @value.getHours()
    @minutes = @value.getMinutes()

  getMonths: (monthFormat) ->
    ( @moment.month(i).format(monthFormat) for i in [0..11] )

  getDays: () ->
    ( i for i in [1..@moment.daysInMonth()] )

  change: (datePart) ->
    val = @[datePart.toLowerCase()]
    if datePart is 'Month'
      val = @months.indexOf(val)

    if datePart in ['Month', 'FullYear']
      d = new Date(@fullyear, @months.indexOf(@month), 1)
      maxDays = @_moment(d).daysInMonth()
      if (@date > maxDays)
        @date = maxDays
        @change('Date')

    @value['set' + datePart] ( val )
    @moment = @_moment(@value)
    if datePart in ['Month', 'FullYear']
      @days = @getDays()
    @onUpdate(@value)

angular
  .module("dateTimePickerNgComponent")
  .component('dtPickerInputPanel', DtPickerInputPanel)
