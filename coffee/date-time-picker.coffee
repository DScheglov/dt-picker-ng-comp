
class DateTimePicker

  @controller: @

  @bindings:
    value: '<'
    dateFormat: '<'
    minuteStep: '<'
    cancelText: '<'
    acceptText: '<'
    visible: '<'
    alwaysVisible: '<'
    onOpen: '<'
    onHide: '<'
    onChange: '<'

  @template: """
    #include('./build/date-time-picker.html')
  """

  constructor: () ->
    @binded =
      update: @update.bind @
      cancel: @cancel.bind @
      accept: @accept.bind @

  $onInit: () ->
    dummy = () ->
    @alwaysVisible = true if not @alwaysVisible?
    @onOpen =  dummy if typeof(@onOpen) isnt "function"
    @onHide = dummy if typeof(@onHide) isnt "function"
    @onChange = dummy if typeof(@onChange) isnt "function"

    @dateFormat = @dateFormat || "DD MMMM YYYY"
    @timeFormat = @timeFormat || "HH:mm"
    @prevValue = @value && new Date(@value)
    @update(@prevValue || new Date())
    @show() if @alwaysVisible or @visible

  $onChanges: () -> @$onInit()

  update: (val) ->
    @value = val? && new Date (val) || @value

  show: () ->
    @visible = true
    @onOpen ( @ )

  hide: () ->
    @visible = false
    @onHide ( @ )

  cancel: () ->
    @update(@prevValue || new Date())
    @hide()

  accept: () ->
    if (!@prevValue or @prevValue.valueOf() != @value.valueOf())
      @onChange ( @value )
    @hide()

angular
	.module('dateTimePickerNgComponent', [])
	.component('dateTimePicker', DateTimePicker)
