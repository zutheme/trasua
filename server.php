<?php

/**
 * Laravel - A PHP Framework For Web Artisans
 *
 * @package  Laravel
 * @author   Taylor Otwell <taylor@laravel.com>
 */



/*

|--------------------------------------------------------------------------

| Run The Application

|--------------------------------------------------------------------------

|

| Once we have the application, we can handle the incoming request

| through the kernel, and send the associated response back to

| the client's browser allowing them to enjoy the creative

| and wonderful application we have prepared for them.

|

*/





$uri = urldecode(
    parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH)
);

// This file allows us to emulate Apache's "mod_rewrite" functionality from the
// built-in PHP web server. This provides a convenient way to test a Laravel
// application without having installed a "real" web server software here.
if ($uri !== '/' && file_exists(__DIR__.'/dashboard/production'.$uri)) {
    return false;
}

require_once __DIR__.'/dashboard/production/index.php';
