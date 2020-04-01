<?php
    require_once "loxberry_web.php";
    
    // This will read your language files to the array $L
    $L = LBSystem::readlanguage("language.ini");
    $template_title = "Raumserver";
    $helplink = "https://www.loxwiki.eu/display/LOXBERRY/Raumserver";
    $helptemplate = "help.html";
    
    LBWeb::lbheader($template_title, $helplink, $helptemplate);
    
    // This is the main area for your plugin
?>
<p>This plugin has no Web UI yet. Have a look <a href="https://www.loxwiki.eu/display/LOXBERRY/Raumserver#Raumserver-Roadmap" target="_blank">here</a> for further details.</p>
 
<?php 
// Finally print the footer 
LBWeb::lbfooter();
?>