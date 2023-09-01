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
    s.nodescriptions = true
    
    // Username field
    o = s.option(form.Value, 'username', _('Account'));
    o.readonly = true;
    
    // Password field
    o = s.option(form.Value, 'password', _('Password'));
    o.password = true;
    o.modalonly = true;
    o.readonly = true;
    
    // MAC Address field (dropdown)
    o = s.option(form.Value, 'macaddr', _('MAC Address'));
    o.password = true;
    o.modalonly = true;
    o.readonly = true;
    
    // Agent field (dropdown)
    o = s.option(form.Value, 'agent', _('Agent'));
    o.readonly = true;
    
    // Package field (dropdown)
    o = s.option(form.Value, 'package', _('Package'));
    o.readonly = true;
    
    // Upload Speed field (dropdown)
    var o = s.option(form.Value, 'urate', _('Upload Speed'));
    o.readonly = true;
    
    // Download Speed field (dropdown)
    var o = s.option(form.Value, 'drate', _('Download Speed'));
    o.readonly = true;
    
    // OLT field (dropdown)
    var o = s.option(form.Value, 'olt', _('OLT'));
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
    
    // PON field (dropdown)
    var o = s.option(form.Value, 'pon', _('PON'));
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
    
    // Serial Number field (dropdown)
    o = s.option(form.Value, 'sn', _('S/N'));
    o.placeholder = 'ONT Serial Number';
    o.password = true;
    o.modalonly = true;
    
    // GPS Location field (dropdown)
    o = s.option(form.Value, 'gps', _('GPS'));
    o.placeholder = 'ONT GPS Location';
    o.modalonly = true;
    
    // Enable Connect field (checkbox)
    o = s.option(form.Flag, 'more', _('Contact'));
    o.rmempty = false;
    o.modalonly = true;
    o.default = '0';
    
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
