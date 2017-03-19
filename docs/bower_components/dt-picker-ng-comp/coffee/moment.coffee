
ensureMoment =
  unless window.moment
    throw new Error('
      dateTimePickerNgComponent:
      monment.js is required for correct work of dateTimePicker.
      Please ensure you correctly linked all requirements.
    ')
  else
    () -> window.moment

angular
  .module('dateTimePickerNgComponent')
  .service('moment', ensureMoment)
