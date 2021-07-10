<?php
include_once("dbconnect.php");

$productName = $_POST['prname'];

$stmt = $conn->prepare("SELECT * FROM tbl_products WHERE prname = '$productName' ");
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $products["products"] = array();
    while ($row = $result->fetch_assoc()) {
        $productlist['productId'] = $row['prid'];
        $productlist['productName'] = $row['prname'];
        $productlist['productType'] = $row['prtype'];
        $productlist['price'] = $row['prprice'];
        $productlist['quantity'] = $row['prqty'];
        $productlist['picture'] = 'https://crimsonwebs.com/s270150/Gadgetou/images/products/' . $row['picture'];
        array_push($products['products'], $productlist);
    }
    $response = array('data' => $products);
    sendJsonResponse($response);
} else {
    echo "nodata";
}

// function for sending json
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>