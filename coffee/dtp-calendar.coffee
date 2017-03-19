
class DtPickerCalendar

  @controller: @
  @inject: [ 'moment' ]

  @bindings:
    value: '<'
    onUpdate: '<'
    dateFormat: '<'

  @template: """
    #include('./build/dtp-calendar.html')
  """

  constructor: (moment)->
    @_moment = moment
    m = moment( '2017-03-19', 'YYYY-MM-DD' )
    @weekdays = ( m.add(1, 'd').format('dd') for i in [0..7] )

  $onInit: () ->
    dummy = () ->
    @onUpdate = dummy if typeof(@onUpdate) isnt 'function'
    @date = new Date( @value.getFullYear(), @value.getMonth(), @value.getDate() )
    @moment = @_moment(@date)
    @current = new Date( @date )
    @monthYearFormat = /[^dmshqDeEwWaAkSxXzZo]+/
      .exec(@dateFormat)[0]
      .replace(/(^\s+)|(\s+$)/g, '')
    @initWeeks()

  $onChanges: ()-> @$onInit()

  initWeeks: () ->
    @moment = @_moment(@date)
    @monthName = @moment.format(@monthYearFormat)
    d = new Date(@date)
    dayOfWeek = ( d.getDay() + 6) % 7
    week = ( { date: null, number: 0, status: 'external' } for j in [0..dayOfWeek-1] )
    @weeks = [ week ]
    maxDays = @moment.daysInMonth()
    for i in [1..maxDays]
      d.setDate(i)
      dayOfWeek = ( d.getDay() + 6) % 7
      week[ dayOfWeek ] =
        date: new Date(d)
        number: d.getDate()
        status: ( if d.valueOf() == @current.valueOf() then 'current' else 'internal' )
      if dayOfWeek is 6 and i < maxDays
        week = [ ]
        @weeks.push( week )
    if dayOfWeek < 6
      @weeks[@weeks.length - 1] = week.concat(
        ( { date: null, number: 0, status: 'external' } for j in [ (dayOfWeek+1)..6] )
      )
    return @weeks;

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
