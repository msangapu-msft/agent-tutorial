<?php

// Allow the script to run indefinitely without timing out (useful for long-running tasks)
set_time_limit(0);

// Limit the maximum memory usage of this PHP script to 32 megabytes (for controlled resource usage/testing)
ini_set('memory_limit', '32M');

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

    // Load JPEGs into an array (in memory)
    for ($x = 0; $x < $maxImages; $x++) {
        // Defensive check for image name existence
        if (isset($imgNames[$x]) && !empty($imgNames[$x])) {
            $imgPath = "./images/" . $imgNames[$x];
            if (file_exists($imgPath)) {
                $imgArray[$x] = imagecreatefromjpeg($imgPath);
            } else {
                error_log("Image file not found: $imgPath");
            }
        } else {
            error_log("Image name missing for index $x");
        }
    }

    // Loop through array and convert each JPEG to PNG
    if (!empty($imgArray)) {
        for ($x = 0; $x < $maxImages; $x++) {
            if (isset($imgArray[$x], $imgNames[$x])) {
                $filename = './images/converted_' . substr($imgNames[$x], 0, -4) . '.png';
                imagepng($imgArray[$x], $filename);
            }
        }
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
