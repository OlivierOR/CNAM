<?php header('Access-Control-Allow-Origin: *');
$ftp_server = "domain";
$ftp_username   = "username";
$ftp_password   =  "password!";

// setup of connection
$conn_id = ftp_connect($ftp_server) or die("Connexion impossible $ftp_server");

// login
if (@ftp_login($conn_id, $ftp_username, $ftp_password))
{
  //echo "connexion reussi $ftp_username@$ftp_server\n";
}
else
{
  echo "impossible de se connecter en tant que $ftp_username\n";
}

//-----------------------------------------------------
// set error reporting level
if (version_compare(phpversion(), '5.3.0', '>=') == 1)
  error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED);
else
  error_reporting(E_ALL & ~E_NOTICE);

function bytesToSize1024($bytes, $precision = 2) {
    $unit = array('B','KB','MB');
    return @round($bytes / pow(1024, ($i = floor(log($bytes, 1024)))), $precision).' '.$unit[$i];
}

if (isset($_FILES['myfile'])) {
    $sFileName = $_FILES['myfile']['name'];
    $sFileType = $_FILES['myfile']['type'];
    $sFileSize = bytesToSize1024($_FILES['myfile']['size'], 1);

    echo <<<EOF
<div class="s">
    <p>Le ficher: {$sFileName} transmis avec succes.</p>
    <p>Type: {$sFileType}</p>
    <p>Taille: {$sFileSize}</p>
</div>
EOF;
} else {
    echo '<div class="f">Erreur survenue</div>';
}
//---------------------
$remote_file_path = "/cnam/input_files/".$sFileName;
ftp_put($conn_id, $remote_file_path, $_FILES['myfile']['tmp_name'],
        FTP_ASCII); 

//------------------------------------------------------------------
ftp_close($conn_id);
//echo "\n\nfermeture connexion";
