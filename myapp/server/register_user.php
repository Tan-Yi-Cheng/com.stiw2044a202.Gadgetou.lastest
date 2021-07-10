<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s270150/Gadgetou/php/PHPMailer-master/src/Exception.php';
require '/home8/crimsonw/public_html/s270150/Gadgetou/php/PHPMailer-master/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s270150/Gadgetou/php/PHPMailer-master/src/SMTP.php';

include_once("dbconnect.php");

$name = $_POST['name'];
$user_email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$rating = "0";
$credit = "0";
$status = "active";

$sqlregister = "INSERT INTO tbl_user(name,user_email,password,otp,rating,credit,status) VALUES('$name','$user_email','$passha1','$otp','$rating','$credit','$status')";
if ($conn->query($sqlregister) === TRUE){
    echo "success";
    sendEmail($otp,$user_email);
}else{
    echo "failed";
}

function sendEmail($otp,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'crimsonwebs.com';                              //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'gadgetou@crimsonwebs.com';                     //SMTP username
    $mail->Password   = '!@#123QWEasd';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "Gadgetou@crimsonwebs.com";
    $to = $user_email;
    $subject = "From Gadgetou. Please Verify Your Account";
    $message = "
    <p>
    Dear $name,
    <p>
    Please click the following link to verify your account<br><br>
    <a href='https://crimsonwebs.com/s270150/Gadgetou/php/verify_account.php?email=".$user_email."&key=".$otp."'>
    Click Here</a>";
    
    $mail->setFrom($from,"Gadgetou");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}


?>