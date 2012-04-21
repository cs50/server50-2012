<?php

/* Servers configuration */
$i = 0;

/* Server: localhost [1] */
$i++;
$cfg['Servers'][$i]['auth_type'] = 'http';
$cfg['Servers'][$i]['auth_http_realm'] = 'CS50 Dev VM';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['extension'] = 'mysqli';
$cfg['Servers'][$i]['hide_db'] = '^(information_schema|mysql|performance_schema|test)$';
$cfg['Servers'][$i]['host'] = 'localhost';

/* End of servers configuration */

$cfg['AjaxEnable'] = false;
$cfg['AllowUserDropDatabase'] = true;
$cfg['DefaultLang'] = 'en';
$cfg['DisplayDatabasesList'] = 1;
$cfg['LeftFrameDBTree'] = false;
$cfg['LeftFrameLight'] = false;
$cfg['NavigationBarIconic'] = 'both';
$cfg['PmaNoRelation_DisableWarning'] = true;
$cfg['RepeatCells'] = 0;
$cfg['SaveDir'] = '';
$cfg['ServerDefault'] = 1;
$cfg['ShowAll'] = true;
$cfg['ShowPhpInfo'] = true;
$cfg['SuggestDBName'] = false;
$cfg['UploadDir'] = '';
$cfg['VersionCheck'] = false;

?>
