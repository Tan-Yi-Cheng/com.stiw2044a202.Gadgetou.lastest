<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$productID = $_POST['prid'];
$cartqty = $_POST['cartqty'];

$sqlupdatecart = "UPDATE tbl_cart SET cartqty='$cartqty' WHERE email = '$email' AND prid = '$productID' ";
if ($conn->query($sqlupdatecart) === TRUE){
    echo "success";
}else if($conn->query($sqlupdatecart) === false){
    echo "failed";
}else {
    echo "";
}
    
?>