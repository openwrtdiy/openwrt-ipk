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
    s.sortable  = false;

    // Enable User field
    o = s.option(form.Flag, 'enabled', _('Enable'));
    o.default = "1"
    
    // Username field
    o = s.option(form.Value, 'username', _('Username'));
    o.placeholder = _('Required');
    o.rmempty = false;

    // Service Name field (dropdown)
    o = s.option(form.ListValue, 'servicename', _('Service Name'));
    o.readonly = true;
    o.value('*', _('Default'));
    o.value('serviceA', 'Service A');
    o.value('serviceB', 'Service B');
    o.value('serviceC', 'Service C');

    // Password field
    o = s.option(form.Value, 'password', _('Password'));
    o.placeholder = _('Required');
    o.password = true;

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
    
    // Package field (dropdown)
    o = s.option(form.ListValue, 'package', _('Package'));
    o.default = 'home';
    o.value('home', _('Home'));
    o.value('office', _('Office'));
    o.value('free', _('Free'));
    o.value('test', _('Test'));

    // Enable QoS field (checkbox)
    o = s.option(form.Flag, 'qos', _('QoS'));
    o.readonly = true;
    o.default = '1';
    o.rmempty = false;

    // Upload Speed field (dropdown)
    var uploadSpeed = s.option(form.ListValue, 'urate', _('Upload Speed'));
    uploadSpeed.default = '3750';
    uploadSpeed.value('1250', '10 Mbps');
    uploadSpeed.value('2500', '20 Mbps');
    uploadSpeed.value('3750', '30 Mbps');
    uploadSpeed.value('5000', '40 Mbps');
    uploadSpeed.value('6250', '50 Mbps');
    uploadSpeed.value('7500', '60 Mbps');
    uploadSpeed.value('8750', '70 Mbps');
    uploadSpeed.value('10000', '80 Mbps');
    uploadSpeed.value('11250', '90 Mbps');
    uploadSpeed.value('12500', '100 Mbps');
    uploadSpeed.value('25000', '200 Mbps');
    uploadSpeed.value('37500', '300 Mbps');
    uploadSpeed.value('50000', '400 Mbps');
    uploadSpeed.value('62500', '500 Mbps');
    uploadSpeed.value('75000', '600 Mbps');
    uploadSpeed.value('87500', '700 Mbps');
    uploadSpeed.value('100000', '800 Mbps');
    uploadSpeed.value('112500', '900 Mbps');
    uploadSpeed.value('125000', '1000 Mbps');
    uploadSpeed.value('156250', '1250 Mbps');
    uploadSpeed.value('312500', '2500 Mbps');
    uploadSpeed.value('1250000', '10000 Mbps');
    uploadSpeed.value('125', '1 Mbps');
    uploadSpeed.value('250', '2 Mbps');
    uploadSpeed.value('375', '3 Mbps');
    uploadSpeed.value('500', '4 Mbps');
    uploadSpeed.value('625', '5 Mbps');
    uploadSpeed.value('750', '6 Mbps');
    uploadSpeed.value('875', '7 Mbps');
    uploadSpeed.value('1000', '8 Mbps');
    uploadSpeed.value('1125', '9 Mbps');
    uploadSpeed.depends('qos', '1'); // Show only when QoS is enabled

    // Download Speed field (dropdown)
    var downloadSpeed = s.option(form.ListValue, 'drate', _('Download Speed'));
    downloadSpeed.default = '3750';
    downloadSpeed.value('1250', '10 Mbps');
    downloadSpeed.value('2500', '20 Mbps');
    downloadSpeed.value('3750', '30 Mbps');
    downloadSpeed.value('5000', '40 Mbps');
    downloadSpeed.value('6250', '50 Mbps');
    downloadSpeed.value('7500', '60 Mbps');
    downloadSpeed.value('8750', '70 Mbps');
    downloadSpeed.value('10000', '80 Mbps');
    downloadSpeed.value('11250', '90 Mbps');
    downloadSpeed.value('12500', '100 Mbps');
    downloadSpeed.value('25000', '200 Mbps');
    downloadSpeed.value('37500', '300 Mbps');
    downloadSpeed.value('50000', '400 Mbps');
    downloadSpeed.value('62500', '500 Mbps');
    downloadSpeed.value('75000', '600 Mbps');
    downloadSpeed.value('87500', '700 Mbps');
    downloadSpeed.value('100000', '800 Mbps');
    downloadSpeed.value('112500', '900 Mbps');
    downloadSpeed.value('125000', '1000 Mbps');
    downloadSpeed.value('156250', '1250 Mbps');
    downloadSpeed.value('312500', '2500 Mbps');
    downloadSpeed.value('1250000', '10000 Mbps');
    downloadSpeed.value('125', '1 Mbps');
    downloadSpeed.value('250', '2 Mbps');
    downloadSpeed.value('375', '3 Mbps');
    downloadSpeed.value('500', '4 Mbps');
    downloadSpeed.value('625', '5 Mbps');
    downloadSpeed.value('750', '6 Mbps');
    downloadSpeed.value('875', '7 Mbps');
    downloadSpeed.value('1000', '8 Mbps');
    downloadSpeed.value('1125', '9 Mbps');
    downloadSpeed.depends('qos', '1'); // Show only when QoS is enabled

    // Speed Unit field (dropdown)
    var speedUnit = s.option(form.ListValue, 'unit', _('Speed Unit'));
    speedUnit.readonly = true;
    speedUnit.default = 'kbytes';
    speedUnit.value('bytes', 'Bytes/s');
    speedUnit.value('kbytes', 'KBytes/s');
    speedUnit.value('mbytes', 'MBytes/s');
    speedUnit.depends('qos', '1'); // Show only when QoS is enabled

    // Connection Number field (dropdown)
    var connectionNumber = s.option(form.ListValue, 'connect', _('Connection Number'));
    connectionNumber.default = '8192';
    connectionNumber.value('3072', '30M Home');
    connectionNumber.value('4096', '40M Home');
    connectionNumber.value('6144', '60M Home');
    connectionNumber.value('8192', '80M Home');
    connectionNumber.value('16384', '100M Office');
    connectionNumber.value('32768', '200M Office');
    connectionNumber.value('65536', '400M Office');
    connectionNumber.value('256', '4M Test');
    connectionNumber.value('512', '8M Test');
    connectionNumber.value('1024', '10M Test');
    connectionNumber.depends('qos', '1'); // Show only when QoS is enabled

    // Opening Date field (read-only)
    o = s.option(form.Value, 'opening', _('Opening Date'));
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

    o.value(formatDate(oneMonthLater));
    o.value(formatDate(threeMonthsLater));
    o.value(formatDate(sixMonthsLater));
    o.value(formatDate(twelveMonthsLater));

    // Submit button
    return m.render();
  },
    handleSave: null,
    handleSaveApply: null,
    handleReset: null
});
