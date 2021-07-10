<?php
include_once("dbconnect.php");

$productName = $_POST['productName'];
$productType = $_POST['productType'];
$price = $_POST['price'];
$quantity = $_POST['quantity'];
$encoded_base64string = $_POST["encoded_base64string"];

//product file name
$picture = uniqid() . '.png';


$sqlregister = "INSERT INTO tbl_products(prid,prname,prtype,prprice,prqty,picture) VALUES(null, '$productName', '$productType', '$price', '$quantity', '$picture')";
if ($conn->query($sqlregister) === TRUE){
    
    $decoded_string = base64_decode($encoded_base64string);
    $path = '../images/products/' . $picture;
    $is_written = file_put_contents($path, $decoded_string);
    
    echo "success";
}else if($conn->query($sqlregister) === false){
    echo "failed";
}else {
    echo "";
}
    
?>