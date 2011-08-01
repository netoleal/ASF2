<?php

$url = "";

if( isset($_GET["url"]))
{
	header('Content-Type: image/jpg');
	$url = $_GET["url"];
}

function loadFile($sFilename, $sCharset = 'UTF-8')
{
    if (floatval(phpversion()) >= 4.3) {
        $sData = file_get_contents($sFilename);
    } else {
        if (!file_exists($sFilename)) return -3;
        $rHandle = fopen($sFilename, 'r');
        if (!$rHandle) return -2;

        $sData = '';
        while(!feof($rHandle))
            $sData .= fread($rHandle, filesize($sFilename));
        fclose($rHandle);
    }
    return $sData;
}

if( $url != "" )
{
	echo loadFile($url, "auto");
}
else
{
	echo "URL não definida";
}

?>