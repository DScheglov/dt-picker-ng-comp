
class DtPickerButtonPanel

  @controller: @

  @bindings:
    onCancel: '<'
    onAccept: '<'
    cacnelText: '<'
    acceptText: '<'
    cancelButtonClass: '<'
    acceptButtonClass: '<'

  @template: """
    <div class="dt-picker-button-panel">
      <div class="cancel-button">
        <button class="dt-picker-btn-cancel"
                ng-class="$ctrl.cancelButtonClass"
                ng-click="$ctrl.onCancel()">
          {{$ctrl.cancelText}}
        </button>
      </div>
      <div class="accept-button">
        <button class="dt-picker-btn-accept"
                ng-class="$ctrl.acceptButtonClass"
                ng-click="$ctrl.onAccept()">
          {{$ctrl.acceptText}}
        </button>
      </div>
    </div>
  """

  constructor: () ->

  $onInit: () ->
    dummy = () ->
    @onCancel = dummy if typeof @onCancel isnt "function"
    @onAccept = dummy if typeof @onAccept isnt "function"
    @cancelText = @cancelText || 'cancel'
    @acceptText = @acceptText || 'ok'

  $onChanges: () -> @$onInit


angular
  .module("dateTimePickerNgComponent")
  .component('dtPickerButtonPanel', DtPickerButtonPanel)
