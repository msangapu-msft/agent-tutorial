<?php
$extension = $_GET['ext'];

$noImages=true;

if ($handle = opendir('./images/.')) {

    while (false !== ($entry = readdir($handle))) {

        if ($entry != "." && $entry != "..") {

            $file_ext = pathinfo($entry, PATHINFO_EXTENSION);
            
            if (strtolower($file_ext) == strtolower($extension) || strtoupper($file_ext) == strtolower($extension)) {
                echo "$entry\n<br/>";
                $noImages=false;
            }
        }
    }

    closedir($handle);
}

if ($noImages) echo "No images found";
