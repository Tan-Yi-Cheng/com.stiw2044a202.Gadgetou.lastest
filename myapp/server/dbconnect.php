<?php
$servername = "localhost";
$username   = "crimsonw_gadgetou";
$password   = "123456789qwertyuiop";
$dbname     = "crimsonw_gadgetoudb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>