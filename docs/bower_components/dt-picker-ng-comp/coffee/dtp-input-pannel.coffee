
class DtPickerInputPanel

  @controller: @
  @inject: [ 'moment', 'capFilter' ]

  @bindings:
    value: '<'
    dateFormat: '<'
    onUpdate: '<'
    minuteStep: '<'

  @template: """
    #include('./build/dtp-input-panel.html')
  """

  constructor: (moment, capFilter) ->
    @_moment = moment
    @filters =
      cap: capFilter
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
    ( @filters.cap( @moment.month(i).format("DD MMMM").split(' ')[1] ) for i in [0..11] )

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
