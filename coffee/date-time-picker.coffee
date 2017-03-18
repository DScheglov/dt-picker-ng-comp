
class DateTimePicker

  @controller: @

  @bindings:
    value: '<'
    dateFormat: '<'
    timeFormat: '<'
    visible: '<'
    onOpen: '<'
    onHide: '<'
    onChange: '<'

  @template: '''
    <div class="dt-picker-ng-comp" ng-show="$ctrl.visible">
      <dt-picker-input-panel
        value="$ctrl.value"
        date-format="$ctrl.dateFormat"
        on-update="$ctrl.binded.update">
      </dt-picker-input-panel>

      <dt-picker-calendar
        value="$ctrl.value"
        date-format="$ctrl.dateFormat"
        on-update="$ctrl.binded.update"
      ></dt-picker-calendar>

      <dt-picker-button-panel
        on-cancel="$ctrl.binded.cancel"
        on-accept="$ctrl.binded.accept">
      </dt-picker-button>
    </div>
  '''

  constructor: () ->
    @binded =
      update: @update.bind @
      cancel: @cancel.bind @
      accept: @accept.bind @

  $onInit: () ->
    dummy = () ->
    @onOpen =  dummy if typeof(@onOpen) isnt "function"
    @onHide = dummy if typeof(@onHide) isnt "function"
    @onChange = dummy if typeof(@onChange) isnt "function"

    @dateFormat = @dateFormat || "DD MMMM YYYY"
    @timeFormat = @timeFormat || "HH:mm"
    @prevValue = @value && new Date(@value)
    @update(@prevValue || new Date())

  $onChanges: () -> @$onInit()

  update: (val) ->
    @value = new Date (val || @value)

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
