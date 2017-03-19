(function() {
  var DateTimePicker;

  DateTimePicker = (function() {
    DateTimePicker.controller = DateTimePicker;

    DateTimePicker.bindings = {
      value: '<',
      dateFormat: '<',
      minuteStep: '<',
      cancelText: '<',
      acceptText: '<',
      visible: '<',
      alwaysVisible: '<',
      onOpen: '<',
      onHide: '<',
      onChange: '<'
    };

    DateTimePicker.template = "<div ng-show=\"$ctrl.alwaysVisible||$ctrl.visible\" class=\"dt-picker-ng-comp\"><dt-picker-input-panel value=\"$ctrl.value\" date-format=\"$ctrl.dateFormat\" on-update=\"$ctrl.binded.update\" minute-step=\"$ctrl.minuteStep\"></dt-picker-input-panel><dt-picker-calendar value=\"$ctrl.value\" date-format=\"$ctrl.dateFormat\" on-update=\"$ctrl.binded.update\"></dt-picker-calendar><dt-picker-button-panel on-cancel=\"$ctrl.binded.cancel\" on-accept=\"$ctrl.binded.accept\" cancel-text=\"$ctrl.cancelText\" accept-text=\"$ctrl.acceptText\"></dt-picker-button-panel></div>";

    function DateTimePicker() {
      this.binded = {
        update: this.update.bind(this),
        cancel: this.cancel.bind(this),
        accept: this.accept.bind(this)
      };
    }

    DateTimePicker.prototype.$onInit = function() {
      var dummy;
      dummy = function() {};
      if (this.alwaysVisible == null) {
        this.alwaysVisible = true;
      }
      if (typeof this.onOpen !== "function") {
        this.onOpen = dummy;
      }
      if (typeof this.onHide !== "function") {
        this.onHide = dummy;
      }
      if (typeof this.onChange !== "function") {
        this.onChange = dummy;
      }
      this.dateFormat = this.dateFormat || "DD MMMM YYYY";
      this.timeFormat = this.timeFormat || "HH:mm";
      this.prevValue = this.value && new Date(this.value);
      this.update(this.prevValue || new Date());
      if (this.alwaysVisible || this.visible) {
        return this.show();
      }
    };

    DateTimePicker.prototype.$onChanges = function() {
      return this.$onInit();
    };

    DateTimePicker.prototype.update = function(val) {
      return this.value = (val != null) && new Date(val || this.value);
    };

    DateTimePicker.prototype.show = function() {
      this.visible = true;
      return this.onOpen(this);
    };

    DateTimePicker.prototype.hide = function() {
      this.visible = false;
      return this.onHide(this);
    };

    DateTimePicker.prototype.cancel = function() {
      this.update(this.prevValue || new Date());
      return this.hide();
    };

    DateTimePicker.prototype.accept = function() {
      if (!this.prevValue || this.prevValue.valueOf() !== this.value.valueOf()) {
        this.onChange(this.value);
      }
      return this.hide();
    };

    return DateTimePicker;

  })();

  angular.module('dateTimePickerNgComponent', []).component('dateTimePicker', DateTimePicker);

}).call(this);

(function() {
  var DtPickerButtonPanel;

  DtPickerButtonPanel = (function() {
    DtPickerButtonPanel.controller = DtPickerButtonPanel;

    DtPickerButtonPanel.bindings = {
      onCancel: '<',
      onAccept: '<',
      cancelText: '<',
      acceptText: '<',
      cancelButtonClass: '<',
      acceptButtonClass: '<'
    };

    DtPickerButtonPanel.template = "<div class=\"dt-picker-button-panel\"><div class=\"cancel-button\"><button ng-class=\"$ctrl.cancelButtonClass\" ng-click=\"$ctrl.onCancel()\" class=\"dt-picker-btn-cancel\">{{$ctrl.cancelText||\"Cancel\"}}</button></div><div class=\"accept-button\"><button ng-class=\"$ctrl.acceptButtonClass\" ng-click=\"$ctrl.onAccept()\" class=\"dt-picker-btn-accept\">{{$ctrl.acceptText||'&#10004;'}}</button></div></div>";

    function DtPickerButtonPanel() {}

    DtPickerButtonPanel.prototype.$onInit = function() {
      var dummy;
      dummy = function() {};
      if (typeof this.onCancel !== "function") {
        this.onCancel = dummy;
      }
      if (typeof this.onAccept !== "function") {
        return this.onAccept = dummy;
      }
    };

    DtPickerButtonPanel.prototype.$onChanges = function() {
      return this.$onInit;
    };

    return DtPickerButtonPanel;

  })();

  angular.module("dateTimePickerNgComponent").component('dtPickerButtonPanel', DtPickerButtonPanel);

}).call(this);

(function() {
  var DtPickerCalendar;

  DtPickerCalendar = (function() {
    DtPickerCalendar.controller = DtPickerCalendar;

    DtPickerCalendar.inject = ['moment'];

    DtPickerCalendar.bindings = {
      value: '<',
      onUpdate: '<',
      dateFormat: '<'
    };

    DtPickerCalendar.template = "<div class=\"date-time-picker-calendar\"><div class=\"calendar-month-switcher\"><div class=\"calendar-month-button\"><a ng-click=\"$ctrl.incMonth(-1)\" href=\"javascript:void(0)\" class=\"btn\">&lsaquo;</a></div><div class=\"calendar-month-name\">{{ $ctrl.monthName|cap }}</div><div class=\"calendar-month-button\"><a ng-click=\"$ctrl.incMonth(1)\" href=\"javascript:void(0)\" class=\"btn\">&rsaquo;</a></div></div><div class=\"calendar-week\"><span ng-repeat=\"dd in $ctrl.weekdays track by $index\" class=\"week-day-header\">{{dd|cap}}</span></div><div class=\"calendar-table\"><table><tr ng-repeat=\"week in $ctrl.weeks track by $index\"><td ng-repeat=\"day in week track by $index\"><span ng-switch=\"day.status\"><span ng-switch-when=\"external\">&nbsp;</span><button ng-switch-when=\"internal\" ng-click=\"$ctrl.update(day.date)\">{{day.number}}</button><span ng-switch-when=\"current\" class=\"active\">{{day.number}}</span></span></td></tr></table></div></div>";

    function DtPickerCalendar(moment) {
      var i, m;
      this._moment = moment;
      m = moment('2017-03-19', 'YYYY-MM-DD');
      this.weekdays = (function() {
        var k, results;
        results = [];
        for (i = k = 0; k <= 7; i = ++k) {
          results.push(m.add(1, 'd').format('dd'));
        }
        return results;
      })();
    }

    DtPickerCalendar.prototype.$onInit = function() {
      var dummy;
      dummy = function() {};
      if (typeof this.onUpdate !== 'function') {
        this.onUpdate = dummy;
      }
      this.date = new Date(this.value.getFullYear(), this.value.getMonth(), this.value.getDate());
      this.moment = this._moment(this.date);
      this.current = new Date(this.date);
      this.monthYearFormat = /[^dmshqDeEwWaAkSxXzZo]+/.exec(this.dateFormat)[0].replace(/(^\s+)|(\s+$)/g, '');
      return this.initWeeks();
    };

    DtPickerCalendar.prototype.$onChanges = function() {
      return this.$onInit();
    };

    DtPickerCalendar.prototype.initWeeks = function() {
      var d, dayOfWeek, i, j, k, maxDays, ref, week;
      this.moment = this._moment(this.date);
      this.monthName = this.moment.format(this.monthYearFormat);
      d = new Date(this.date);
      dayOfWeek = (d.getDay() + 6) % 7;
      week = (function() {
        var k, ref, results;
        results = [];
        for (j = k = 0, ref = dayOfWeek - 1; 0 <= ref ? k <= ref : k >= ref; j = 0 <= ref ? ++k : --k) {
          results.push({
            date: null,
            number: 0,
            status: 'external'
          });
        }
        return results;
      })();
      this.weeks = [week];
      maxDays = this.moment.daysInMonth();
      for (i = k = 1, ref = maxDays; 1 <= ref ? k <= ref : k >= ref; i = 1 <= ref ? ++k : --k) {
        d.setDate(i);
        dayOfWeek = (d.getDay() + 6) % 7;
        week[dayOfWeek] = {
          date: new Date(d),
          number: d.getDate(),
          status: (d.valueOf() === this.current.valueOf() ? 'current' : 'internal')
        };
        if (dayOfWeek === 6 && i < maxDays) {
          week = [];
          this.weeks.push(week);
        }
      }
      if (dayOfWeek < 6) {
        this.weeks[this.weeks.length - 1] = week.concat((function() {
          var l, ref1, results;
          results = [];
          for (j = l = ref1 = dayOfWeek + 1; ref1 <= 6 ? l <= 6 : l >= 6; j = ref1 <= 6 ? ++l : --l) {
            results.push({
              date: null,
              number: 0,
              status: 'external'
            });
          }
          return results;
        })());
      }
      return this.weeks;
    };

    DtPickerCalendar.prototype.incMonth = function(delta) {
      this.date.setMonth(this.date.getMonth() + delta);
      this.initWeeks();
    };

    DtPickerCalendar.prototype.update = function(val) {
      this.value.setFullYear(val.getFullYear());
      this.value.setMonth(val.getMonth());
      this.value.setDate(val.getDate());
      this.onUpdate(this.value);
    };

    return DtPickerCalendar;

  })();

  angular.module("dateTimePickerNgComponent").component('dtPickerCalendar', DtPickerCalendar);

}).call(this);

(function() {
  var cap;

  cap = function(s) {
    return typeof s === 'string' && s.replace(/^./, (function(_this) {
      return function(c) {
        return c.toUpperCase();
      };
    })(this)) || s;
  };

  angular.module('dateTimePickerNgComponent').filter('cap', function() {
    return cap;
  });

}).call(this);

(function() {
  var DtPickerInputPanel;

  DtPickerInputPanel = (function() {
    DtPickerInputPanel.controller = DtPickerInputPanel;

    DtPickerInputPanel.inject = ['moment', 'capFilter'];

    DtPickerInputPanel.bindings = {
      value: '<',
      dateFormat: '<',
      onUpdate: '<',
      minuteStep: '<'
    };

    DtPickerInputPanel.template = "<div class=\"dt-picker-input-panel row\"><div class=\"dt-date input-group\"><select ng-model=\"$ctrl.date\" ng-change=\"$ctrl.change('Date')\" ng-options=\"(d&lt;10?&quot;0&quot;+d:d) for d in $ctrl.days track by d\"></select> /&nbsp;<select ng-model=\"$ctrl.month\" ng-change=\"$ctrl.change('Month')\" ng-options=\"m for m in $ctrl.months track by m\"></select> /&nbsp;<input ng-model=\"$ctrl.fullyear\" ng-change=\"$ctrl.change('FullYear')\" class=\"col-3\"/></div><div class=\"dt-time input-group\"><select ng-model=\"$ctrl.hours\" ng-change=\"$ctrl.change('Hours')\" ng-options=\"(h&lt;10?&quot;0&quot;+h:h) for h in $ctrl.allHours track by h\"></select>&nbsp;:&nbsp;<select ng-model=\"$ctrl.minutes\" ng-change=\"$ctrl.change('Minutes')\" ng-options=\"(m&lt;10?&quot;0&quot;+m:m) for m in $ctrl.allMinutes track by m\"></select></div></div>";

    function DtPickerInputPanel(moment, capFilter) {
      var i;
      this._moment = moment;
      this.filters = {
        cap: capFilter
      };
      this.allHours = (function() {
        var j, results;
        results = [];
        for (i = j = 0; j <= 23; i = ++j) {
          results.push(i);
        }
        return results;
      })();
    }

    DtPickerInputPanel.prototype.$onChanges = function() {
      return this.$onInit();
    };

    DtPickerInputPanel.prototype.$onInit = function() {
      var dummy, i, m, minsCount;
      dummy = function() {};
      if (typeof this.onUpdate !== 'function') {
        this.onUpdate = dummy;
      }
      this.moment = this._moment(this.value);
      this.months = this.getMonths(/M+/.exec(this.dateFormat)[0]);
      this.minuteStep = this.minuteStep || 5;
      minsCount = 60 / this.minuteStep;
      if ((m = parseInt(minsCount)) < minsCount) {
        minsCount = m;
      } else {
        minsCount = m - 1;
      }
      this.allMinutes = (function() {
        var j, ref, results;
        results = [];
        for (i = j = 0, ref = minsCount; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
          results.push(i * this.minuteStep);
        }
        return results;
      }).call(this);
      this.days = this.getDays();
      this.date = this.value.getDate();
      this.month = this.months[this.value.getMonth()];
      this.fullyear = this.value.getFullYear();
      this.hours = this.value.getHours();
      return this.minutes = this.value.getMinutes();
    };

    DtPickerInputPanel.prototype.getMonths = function(monthFormat) {
      var i, j, results;
      results = [];
      for (i = j = 0; j <= 11; i = ++j) {
        results.push(this.filters.cap(this.moment.month(i).format("DD MMMM").split(' ')[1]));
      }
      return results;
    };

    DtPickerInputPanel.prototype.getDays = function() {
      var i, j, ref, results;
      results = [];
      for (i = j = 1, ref = this.moment.daysInMonth(); 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
        results.push(i);
      }
      return results;
    };

    DtPickerInputPanel.prototype.change = function(datePart) {
      var d, maxDays, val;
      val = this[datePart.toLowerCase()];
      if (datePart === 'Month') {
        val = this.months.indexOf(val);
      }
      if (datePart === 'Month' || datePart === 'FullYear') {
        d = new Date(this.fullyear, this.months.indexOf(this.month), 1);
        maxDays = this._moment(d).daysInMonth();
        if (this.date > maxDays) {
          this.date = maxDays;
          this.change('Date');
        }
      }
      this.value['set' + datePart](val);
      this.moment = this._moment(this.value);
      if (datePart === 'Month' || datePart === 'FullYear') {
        this.days = this.getDays();
      }
      return this.onUpdate(this.value);
    };

    return DtPickerInputPanel;

  })();

  angular.module("dateTimePickerNgComponent").component('dtPickerInputPanel', DtPickerInputPanel);

}).call(this);

(function() {
  var ensureMoment;

  ensureMoment = (function() {
    if (!window.moment) {
      throw new Error('dateTimePickerNgComponent: monment.js is required for correct work of dateTimePicker. Please ensure you correctly linked all requirements.');
    } else {
      return function() {
        return window.moment;
      };
    }
  })();

  angular.module('dateTimePickerNgComponent').service('moment', ensureMoment);

}).call(this);
