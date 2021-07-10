<?php
include_once("dbconnect.php");

$prid = $_POST['prid'];

$sqldelproduct = "DELETE FROM tbl_products WHERE prid = '$prid'";
if ($conn->query($sqldelproduct) === TRUE) {
    echo "success";
} else {
    echo "failed";
}
?>