<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];

$sqldelcartitem = "DELETE FROM tbl_cart WHERE prid = '$prid' AND email = '$email' ";
if ($conn->query($sqldelcartitem) === TRUE) {
    echo "success";
} else {
    echo "failed";
}
?>