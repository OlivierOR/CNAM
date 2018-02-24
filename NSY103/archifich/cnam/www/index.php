<!DOCTYPE html>
<html lang="en" >
    <head>
        <meta charset="utf-8" />
        <title>Glisser et deposer plusieurs fichiers</title>
        <link href="css/main.css" rel="stylesheet" type="text/css" />

        <!--[if lt IE 9]>
          <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
    </head>
    <body>
        <header tabindex="0">
            <h2>TRIE ET ARCHIVAGE DE FICHIER</h2>
        </header>

        <div class="container">
            <div class="contr"><h2>Glisser et deposer plusieurs fichiers(5 max à la fois, taille max 256kb)</h2>
<a href="archive.php">archive</a>
</div>
            <div class="upload_form_cont">
                <div id="dropArea">Deposer ici</div>

                <div class="info">
                    <div>Fichiers restants: <span id="count">0</span></div>
                    <!--<div>Destination url: <input id="url" value="http://www.krymo.fr/_upload.php"/></div>-->
                    <input type="hidden" id="url" value="nom_domaine/_upload.php"/>
                    <h2>Resultat:</h2>
                    <div id="result"></div>
                    <canvas width="500" height="20"></canvas>
                </div>
            </div>
        </div>
        <script src="js/script.js"></script>
    </body>
</html>