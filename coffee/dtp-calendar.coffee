
class DtPickerCalendar

  @controller: @
  @inject: [ 'moment' ]

  @bindings:
    value: '<'
    onUpdate: '<'
    dateFormat: '<'

  @template: """
    <div class="calendar-month-switcher">
      <div class="calendar-month-back-button" ng-click="$ctrl.incMonth(-1)">&lt;</div>
      <div class="calendar-month-name">{{ $ctrl.moment.format($ctrl.monthYearFormat)}}</div>
      <div class="calendar-month-back-button" ng-click="$ctrl.incMonth(1)">&gt;</div>
    </div>
    <div class="calendar-week">
    </div>
    <div class="calendar-table">
      <table>
        <tr ng-repeat="week in $ctrl.weeks track by $index">
          <td ng-repeat="day in week track by $index"
              ng-class="day.current"
              ng-click="day.date && $ctrl.update(day.date)">
            {{day.number || "&nbsp;"}}
          </td>
          <!--dt-picker-calendar-cell
            ng-repeat="day in week" day="{{day}}"
          ></dt-picker-calendar-cell-->
        </tr>
      </table>
    </div>
  """

  constructor: (moment)->
    @_moment = moment

  $onInit: () ->
    dummy = () ->
    @onUpdate = dummy if typeof(@onUpdate) isnt 'function'
    @date = new Date( @value.getFullYear(), @value.getMonth(), @value.getDate() )
    @moment = @_moment(@date)
    @current = new Date( @date )
    @monthYearFormat = /[^dmshqDeEwWaAkSxXzZo]+/.exec(@dateFormat)[0]
    @initWeeks()

  $onChanges: ()-> @$onInit()

  initWeeks: () ->
    @moment = @_moment(@date)
    d = new Date(@date)
    dayOfWeek = ( d.getDay() + 6) % 7
    week = ( { date: null, number: 0 } for j in [0..dayOfWeek-1] )
    @weeks = [ week ]
    maxDays = @moment.daysInMonth()
    for i in [1..maxDays]
      d.setDate(i)
      dayOfWeek = ( d.getDay() + 6) % 7
      week[ dayOfWeek ] =
        date: new Date(d)
        number: d.getDate()
        current: ( if d.valueOf() == @current.valueOf() then 'active' else '' )
      if dayOfWeek is 6 and i < maxDays
        week = [ ]
        @weeks.push( week )
    @weeks[@weeks.length - 1] = week.concat(
      ( { date: null, number: 0 } for j in [ (dayOfWeek+1)..6] )
    )

  incMonth: (delta) ->
    @date.setMonth(@date.getMonth() + delta)
    @initWeeks()
    return

  update: (val) ->
    @value.setFullYear(val.getFullYear())
    @value.setMonth(val.getMonth())
    @value.setDate(val.getDate())
    @onUpdate(@value)
    return

angular
  .module("dateTimePickerNgComponent")
  .component('dtPickerCalendar', DtPickerCalendar)
