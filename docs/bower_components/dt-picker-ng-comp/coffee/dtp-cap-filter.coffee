
cap = (s) -> typeof(s) is 'string' and s.replace(/^./, (c) => c.toUpperCase()) or s

angular
  .module('dateTimePickerNgComponent')
  .filter('cap', () -> cap)
