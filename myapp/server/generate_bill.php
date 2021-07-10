<?php
error_reporting(0);
//include_once("dbconnect.php");


$email = $_GET['email'];
$name = $_GET['name'];
$amount = $_GET['amount'];

$api_key ='025172da-37e0-4c3a-af0d-bcbed63e4ff4';
$collection_id = 'syfetegb';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';

$data = array(
    'collection_id' => $collection_id,
    'email'=> $email,
    'name'=> $name,
    'amount'=> $amount * 100,
    'description' => 'Payment for buying ',
    'callback_url'=> "https://crimsonwebs.com/s270150/Gadgetou/php/return_url",
    'redirect_url'=> "https://crimsonwebs.com/s270150/Gadgetou/php/payment_update.php?userid=$email&amount=$amount&orderid=$orderid" ,
    );

$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 


$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return,true);

echo "<pre>".print_r($bill,true)."</pre";
header("Location: {$bill['url']}");

?>