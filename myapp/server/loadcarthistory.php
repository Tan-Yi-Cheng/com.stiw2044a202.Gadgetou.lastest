<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$stmt = $conn->prepare("SELECT * FROM tbl_carthistory WHERE email = '$email'");
$stmt->execute();
$result = $stmt->get_result();


if ($result->num_rows > 0) {
    $products["products"] = array();
    while ($row = $result->fetch_assoc()) {
        $cartlist['productId'] = $row['prid'];//id//name//cquantiti//price
        $cartlist['prname'] = $row['prname'];
        $cartlist['price'] = $row['prprice'];
        $cartlist['cartqty'] = $row['cartqty'];
        array_push($products['products'], $cartlist);
    }
    $response = array('status' => 'success', 'cart' => $products);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'cart' => null);
    sendJsonResponse($response);
}

// function for sending json
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>