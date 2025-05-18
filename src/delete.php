<?php


$noImages=true;
$extension="png";

if ($handle = opendir('./images/.')) {

    while (false !== ($entry = readdir($handle))) {

        if ($entry != "." && $entry != "..") {

            $file_ext = pathinfo($entry, PATHINFO_EXTENSION);
            
            if (strtolower($file_ext) == strtolower($extension) || strtoupper($file_ext) == strtolower($extension)) {
                
                if (!unlink('./images/'.$entry)){
                  echo ("Error deleting $entry <br/>\n");
                }
                else {
                  echo ("Deleted $entry <br/>\n");
                  $noImages=false;
                }
            }
        }
    }

    closedir($handle);
}

if ($noImages) echo "No images found";