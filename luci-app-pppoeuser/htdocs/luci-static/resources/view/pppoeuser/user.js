'use strict';
'require view';
'require form';
'require ui';

return view.extend({
  render: function () {
    var m, s, o;
    
    m = new form.Map('pppoeuser', _(''), _(''));
    
    // User section
    s = m.section(form.GridSection, 'user', _('User List'));
    s.anonymous = true;
    s.addremove = true;
    s.nodescriptions = true
    s.sortable  = false;
    s.removebutton = false;
    s.addbutton = false;
    s.rowcolorsboolean = true;
    s.nomap = true;
    
    // Enable User field
    o = s.option(form.Flag, 'enabled', _('Enable'));
    o.rmempty = false;
    o.default = "1"
    
    // Username field
    o = s.option(form.Value, 'username', _('Account'));
    o.placeholder = _('Required');
    o.rmempty = false;
    o.validate = function (section_id, value) {
    // Validate the input value to match the alphanumeric format
    if (!/^[a-zA-Z0-9]+$/.test(value)) {
        return _('Invalid username format. Only alphanumeric characters are allowed.');
    }
    // Check the length of the username
    if (value.length < 4 || value.length > 16) {
        return _('Username length must be between 4 and 16 characters.');
    }
    
    return true;
    };
    
    // Service Name field (dropdown)
    o = s.option(form.ListValue, 'servicename', _('Service Name'));
    o.readonly = true;
    o.modalonly = true;
    o.value('*', _('Default'));
    o.value('serviceA', 'Service A');
    o.value('serviceB', 'Service B');
    o.value('serviceC', 'Service C');
    
    // Password field
    o = s.option(form.Value, 'password', _('Password'));
    o.placeholder = _('Required');
    o.password = true;
    o.modalonly = true;
    o.validate = function (section_id, value) {
    // Validate the input value to ensure it's between 8 and 16 characters
    if (value.length < 8 || value.length > 16) {
    return _('Password must be between 8 and 16 characters.');
    }
    return true;
    };
    
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = ('0' + (currentDate.getMonth() + 1)).slice(-2);
    var day = ('0' + currentDate.getDate()).slice(-2);
    var formattedDate = year + month + day;
    
    o.default = formattedDate.slice(0, 8);
    o.rmempty = false; // Make the field required
    
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = ('0' + (currentDate.getMonth() + 1)).slice(-2);
    var day = ('0' + currentDate.getDate()).slice(-2);
    var formattedDate = year + month + day;
    
    o.default = formattedDate.slice(0, 8);
    o.rmempty = false; // Make the field required
    
    // IP Address field (custom input with default value *)
    o = s.option(form.Value, 'ipaddr', _('IP Address'));
    o.placeholder = _('Required');
    o.default = '*';
    o.value('*', _('Default'));
    o.validate = function (section_id, value) {
    // Skip validation if the value is '*'
    if (value === '*') {
    return true;
    }
    // Validate the input value to match the format x.x.x.x or x:x:x:x:x:x:x:x
    if (!/^([\d]{1,3}\.){3}[\d]{1,3}$|^([\da-fA-F]{1,4}:){7}[\da-fA-F]{1,4}$/.test(value)) {
    return _('Invalid IP address format.');
    }
    return true;
    };
    
    // MAC Address field (dropdown)
    o = s.option(form.Value, 'macaddr', _('MAC Address'));
    o.modalonly = true;
    o.placeholder = 'MAC Address';
    o.password = true;
    o.readonly = true;
    
    // Package field (dropdown)
    o = s.option(form.ListValue, 'package', _('Package'));
    o.default = 'home';
    o.value('home', _('Home'));
    o.value('office', _('Office'));
    o.value('free', _('Free'));
    o.value('test', _('Test'));
    
    // Enable QoS field (checkbox)
    o = s.option(form.Flag, 'qos', _('QoS'));
    o.default = '1';
    o.readonly = true;
    o.modalonly = true;
    
    // Upload Speed field (dropdown)
    var o = s.option(form.ListValue, 'urate', _('Upload Speed'));
    o.default = '3750';
    o.value('1250', '10 Mbps');
    o.value('2500', '20 Mbps');
    o.value('3750', '30 Mbps');
    o.value('5000', '40 Mbps');
    o.value('6250', '50 Mbps');
    o.value('7500', '60 Mbps');
    o.value('8750', '70 Mbps');
    o.value('10000', '80 Mbps');
    o.value('11250', '90 Mbps');
    o.value('12500', '100 Mbps');
    o.value('25000', '200 Mbps');
    o.value('37500', '300 Mbps');
    o.value('50000', '400 Mbps');
    o.value('62500', '500 Mbps');
    o.value('75000', '600 Mbps');
    o.value('87500', '700 Mbps');
    o.value('100000', '800 Mbps');
    o.value('112500', '900 Mbps');
    o.value('125000', '1000 Mbps');
    o.value('156250', '1250 Mbps');
    o.value('312500', '2500 Mbps');
    o.value('1250000', '10000 Mbps');
    o.value('125', '1 Mbps');
    o.value('250', '2 Mbps');
    o.value('375', '3 Mbps');
    o.value('500', '4 Mbps');
    o.value('625', '5 Mbps');
    o.value('750', '6 Mbps');
    o.value('875', '7 Mbps');
    o.value('1000', '8 Mbps');
    o.value('1125', '9 Mbps');
    o.depends('qos', '1'); // Show only when QoS is enabled
    
    // Download Speed field (dropdown)
    var o = s.option(form.ListValue, 'drate', _('Download Speed'));
    o.default = '3750';
    o.value('1250', '10 Mbps');
    o.value('2500', '20 Mbps');
    o.value('3750', '30 Mbps');
    o.value('5000', '40 Mbps');
    o.value('6250', '50 Mbps');
    o.value('7500', '60 Mbps');
    o.value('8750', '70 Mbps');
    o.value('10000', '80 Mbps');
    o.value('11250', '90 Mbps');
    o.value('12500', '100 Mbps');
    o.value('25000', '200 Mbps');
    o.value('37500', '300 Mbps');
    o.value('50000', '400 Mbps');
    o.value('62500', '500 Mbps');
    o.value('75000', '600 Mbps');
    o.value('87500', '700 Mbps');
    o.value('100000', '800 Mbps');
    o.value('112500', '900 Mbps');
    o.value('125000', '1000 Mbps');
    o.value('156250', '1250 Mbps');
    o.value('312500', '2500 Mbps');
    o.value('1250000', '10000 Mbps');
    o.value('125', '1 Mbps');
    o.value('250', '2 Mbps');
    o.value('375', '3 Mbps');
    o.value('500', '4 Mbps');
    o.value('625', '5 Mbps');
    o.value('750', '6 Mbps');
    o.value('875', '7 Mbps');
    o.value('1000', '8 Mbps');
    o.value('1125', '9 Mbps');
    o.depends('qos', '1'); // Show only when QoS is enabled
    
    // Speed Unit field (dropdown)
    var o = s.option(form.ListValue, 'unit', _('Speed Unit'));
    o.modalonly = true;
    o.readonly = true;
    o.default = 'kbytes';
    o.value('bytes', 'Bytes/s');
    o.value('kbytes', 'KBytes/s');
    o.value('mbytes', 'MBytes/s');
    o.depends('qos', '1'); // Show only when QoS is enabled
    
    // Connection Number field (dropdown)
    var o = s.option(form.ListValue, 'connect', _('Connection Number'));
    o.default = '8192';
    o.value('256', _('256') + ' (Test)');
    o.value('512', _('512') + ' (Test)');
    o.value('1024', _('1024') + ' (Test)');
    o.value('3072', _('3072') + ' (30M Home)');
    o.value('4096', _('4096') + ' (40M Home)');
    o.value('6144', _('6144') + ' (60M Home)');
    o.value('8192', _('8192') + ' (80M Home)');
    o.value('16384', _('16384') + ' (100M Office)');
    o.value('32768', _('32768') + ' (200M Office)');
    o.value('65536', _('65536') + ' (400M Office)');
    o.depends('qos', '1'); // Show only when QoS is enabled
    
    // Opening Date field (read-only)
    o = s.option(form.Value, 'opening', _('Opening Date'));
    o.modalonly = true;
    o.readonly = true;
    // Automatically populate with the current date in 'YYYY-MM-DD' format
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = ('0' + (currentDate.getMonth() + 1)).slice(-2);
    var day = ('0' + currentDate.getDate()).slice(-2);
    var formattedDate = year + '-' + month + '-' + day;
    o.default = formattedDate;
    
    // Expiration Date field
    o = s.option(form.Value, 'expires', _('Expiration Date'));
    o.datatype = 'string';
    o.placeholder = 'YYYY-MM-DD';
    o.validate = function (section_id, value) {
    // Validate the input value to match the format YYYY-MM-DD
    if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) {
    return _('Invalid date format. Please use YYYY-MM-DD.');
    }
    
    // Split the date string into year, month, and day components
    var parts = value.split('-');
    var year = parseInt(parts[0], 10);
    var month = parseInt(parts[1], 10);
    var day = parseInt(parts[2], 10);
    
    // Validate the year, month, and day values
    if (isNaN(year) || isNaN(month) || isNaN(day)) {
    return _('Invalid date values.');
    }
    
    if (month < 1 || month > 12) {
    return _('Invalid month. Please use a value between 01 and 12.');
    }
    
    var daysInMonth = new Date(year, month, 0).getDate();
    if (day < 1 || day > daysInMonth) {
    return _('Invalid day. Please use a value between 01 and ') + daysInMonth + '.';
    }
    
    return true;
    };    
    var currentDate = new Date();
    
    // Calculate expiration dates based on the current day + 1/3/6/12 months
    var oneMonthLater = new Date(currentDate);
    oneMonthLater.setMonth(currentDate.getMonth() + 1);
    var threeMonthsLater = new Date(currentDate);
    threeMonthsLater.setMonth(currentDate.getMonth() + 3);
    var sixMonthsLater = new Date(currentDate);
    sixMonthsLater.setMonth(currentDate.getMonth() + 6);
    var twelveMonthsLater = new Date(currentDate);
    twelveMonthsLater.setMonth(currentDate.getMonth() + 12);
    
    // Convert calculated dates to YYYY-MM-DD format
    function formatDate(date) {
      var year = date.getFullYear();
      var month = (date.getMonth() + 1).toString().padStart(2, '0');
      var day = date.getDate().toString().padStart(2, '0');
      return year + '-' + month + '-' + day;
    }
    // Set the default value to three months later
    o.default = formatDate(threeMonthsLater);
    o.value(formatDate(oneMonthLater), formatDate(oneMonthLater) + ' ' + _('One Month'));
    o.value(formatDate(threeMonthsLater), formatDate(threeMonthsLater) + ' ' + _('Three Months'));
    o.value(formatDate(sixMonthsLater), formatDate(sixMonthsLater) + ' ' + _('Six Months'));
    o.value(formatDate(twelveMonthsLater), formatDate(twelveMonthsLater) + ' ' + _('Twelve Months'));
 
     // Agent field (dropdown)
    o = s.option(form.Value, 'agent', _('Agent'));
    o.modalonly = true;
    o.readonly = true;
    
    // Enable ONT field (checkbox)
    o = s.option(form.Flag, 'ont', _('ONT'));
    o.modalonly = true;
    o.default = '0';
    o.rmempty = false;
    
    // OLT field (dropdown)
    var o = s.option(form.Value, 'olt', _('OLT'));
    o.modalonly = true;
    o.value('olt1', 'OLT 1');
    o.value('olt2', 'OLT 2');
    o.value('olt3', 'OLT 3');
    o.value('olt4', 'OLT 4');
    o.value('olt5', 'OLT 5');
    o.value('olt6', 'OLT 6');
    o.value('olt7', 'OLT 7');
    o.value('olt8', 'OLT 8');
    o.value('olt9', 'OLT 9');
    o.value('olt10', 'OLT 10');
    o.value('olt11', 'OLT 11');
    o.value('olt12', 'OLT 12');
    o.value('olt13', 'OLT 13');
    o.value('olt14', 'OLT 14');
    o.value('olt15', 'OLT 15');
    o.value('olt16', 'OLT 16');
    o.value('olt17', 'OLT 17');
    o.value('olt18', 'OLT 18');
    o.value('olt19', 'OLT 19');
    o.value('olt20', 'OLT 20');
    o.depends('ont', '1');
    
    // PON field (dropdown)
    var o = s.option(form.Value, 'pon', _('PON'));
    o.modalonly = true;
    o.value('pon1', 'PON 1');
    o.value('pon2', 'PON 2');
    o.value('pon3', 'PON 3');
    o.value('pon4', 'PON 4');
    o.value('pon5', 'PON 5');
    o.value('pon6', 'PON 6');
    o.value('pon7', 'PON 7');
    o.value('pon8', 'PON 8');
    o.value('pon9', 'PON 9');
    o.value('pon10', 'PON 10');
    o.value('pon11', 'PON 11');
    o.value('pon12', 'PON 12');
    o.value('pon13', 'PON 13');
    o.value('pon14', 'PON 14');
    o.value('pon15', 'PON 15');
    o.value('pon16', 'PON 16');
    o.depends('ont', '1');
    
    // Serial Number field (dropdown)
    o = s.option(form.Value, 'sn', _('S/N'));
    o.modalonly = true;
    o.placeholder = 'ONT Serial Number';
    o.depends('ont', '1');
    
    // GPS Location field (dropdown)
    o = s.option(form.Value, 'gps', _('GPS'));
    o.modalonly = true;
    o.placeholder = 'ONT GPS Location';
    o.depends('ont', '1');
    
    // Enable Connect field (checkbox)
    o = s.option(form.Flag, 'more', _('Contact'));
    o.modalonly = true;
    o.default = '0';
    o.rmempty = false;
    
    // Address field (dropdown)
    o = s.option(form.Value, 'address', _('Address'));
    o.modalonly = true;
    o.placeholder = 'User Address';
    o.depends('more', '1');
    
    // E-mail field (dropdown)
    o = s.option(form.DynamicList, 'mail', _('E-mail'));
    o.modalonly = true;
    o.placeholder = 'User Email';
    o.depends('more', '1');
    
    // Phone field (dropdown)
    o = s.option(form.DynamicList, 'phone', _('Telephone'));
    o.modalonly = true;
    o.placeholder = 'User Phone';
    o.depends('more', '1');
    
    o = s.option(form.TextValue, 'notes', _('Notes'), _(''));
    o.modalonly = true;
    o.optional = true;
    o.depends('more', '1');
    
    // Submit button
    return m.render();
  },
    handleSave: null,
    handleSaveApply: null,
    handleReset: null
});
