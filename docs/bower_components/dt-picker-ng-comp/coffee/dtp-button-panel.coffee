
class DtPickerButtonPanel

  @controller: @

  @bindings:
    onCancel: '<'
    onAccept: '<'
    cancelText: '<'
    acceptText: '<'
    cancelButtonClass: '<'
    acceptButtonClass: '<'

  @template: """
    #include('./build/dtp-button-panel.html')
  """

  constructor: () ->

  $onInit: () ->
    dummy = () ->
    @onCancel = dummy if typeof @onCancel isnt "function"
    @onAccept = dummy if typeof @onAccept isnt "function"

  $onChanges: () -> @$onInit


angular
  .module("dateTimePickerNgComponent")
  .component('dtPickerButtonPanel', DtPickerButtonPanel)
