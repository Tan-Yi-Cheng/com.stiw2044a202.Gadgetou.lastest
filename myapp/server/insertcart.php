<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$productID = $_POST['prid'];
$productName = $_POST['productName'];
$price = $_POST['price'];
$picture = $_POST['picture'];

//product file name

$sqlinsertcart = "INSERT INTO tbl_cart(email,prid,prname,prprice,picture) VALUES('$email', '$productID', '$productName', '$price', '$picture')";
if ($conn->query($sqlinsertcart) === TRUE){
    echo "success";
}else if($conn->query($sqlinsertcart) === false){
    echo "failed";
}else {
    echo "";
}
    
?>