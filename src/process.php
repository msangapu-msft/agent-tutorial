<?php

// Allow the script to run indefinitely without timing out (useful for long-running tasks)
set_time_limit(0);

// Enable reporting of all PHP errors, warnings, and notices (useful for debugging)
error_reporting(E_ALL);

// Enable logging of PHP errors to a log file instead of displaying them to the user
ini_set('log_errors', 1);

// Specify the file where PHP errors should be logged (Azure App Service log directory)
ini_set('error_log', '/home/LogFiles/php_errors.log');


// Shutdown handler for fatal errors (like memory exhaustion)
register_shutdown_function(function() {
    $error = error_get_last();
    if ($error !== NULL && $error['type'] === E_ERROR) {
        error_log("Fatal Error Caught: " . $error['message']);
        http_response_code(500);
        // Return a structured JSON error response
        header('Content-Type: application/json');
        echo json_encode([
            'error' => 'Fatal Error',
            'message' => 'A critical server error occurred.'
        ]);
    }
});

try {
    // Retrieve query parameters safely
    $maxImages = isset($_GET['images']) ? (int)$_GET['images'] : 0;
    $imgNamesParam = isset($_GET['imgNames']) ? $_GET['imgNames'] : '';
    $imgNames = explode(",", $imgNamesParam);

    // Initialize image array to avoid undefined variable warning
    $imgArray = [];

    // Loop through array and convert each JPEG to PNG
    for ($x=0; $x<$maxImages; $x++){
        $filename = './images/converted_' . substr($imgNames[$x],0,-4) . '.png';
        imagepng(imagecreatefromjpeg("./images/" . $imgNames[$x]), $filename);
    }


} catch (Exception $e) {
    // Catch application-level exceptions
    error_log("Exception caught: " . $e->getMessage());
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'error' => 'Application Error',
        'message' => $e->getMessage()
    ]);
    exit();
}
