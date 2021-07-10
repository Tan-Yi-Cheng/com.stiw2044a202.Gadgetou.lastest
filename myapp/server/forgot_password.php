<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s270150/Gadgetou/php/PHPMailer-master/src/Exception.php';
require '/home8/crimsonw/public_html/s270150/Gadgetou/php/PHPMailer-master/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s270150/Gadgetou/php/PHPMailer-master/src/SMTP.php';

include_once("dbconnect.php");

$user_email = $_POST['email'];
$newotp = rand(1000,9999);
$newpass = random_password(10);
$passha = sha1($newpass);

$sql = "SELECT * FROM tbl_user WHERE user_email = '$user_email'";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE tbl_user SET otp = '$newotp', password = '$passha' WHERE user_email = '$user_email'";
        if ($conn->query($sqlupdate) === TRUE){
                sendEmail($newotp,$newpass,$user_email);
                echo 'success';
        }else{
                echo 'failed';
        }
    }else{
        echo "failed";
    }

function sendEmail($otp,$newpass,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                   //Disable verbose debug output
    $mail->isSMTP();                                        //Send using SMTP
    $mail->Host       = 'crimsonwebs.com';                  //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                               //Enable SMTP authentication
    $mail->Username   = 'gadgetou@crimsonwebs.com';         //SMTP username
    $mail->Password   = '!@#123QWEasd';                     //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    
    $from = "gadgetou@crimsonwebs.com";
    $to = $user_email;
    $subject = "From Gadgetou. Please Verify Your Account";
    $message = "
    <p>
    Dear $name, 
    <p>
    Your password has been reset.The new password is at the below.</p><br><br>
    <h3>Password:".$newpass."</h3><br><br>
    Please click the link below to reactivate your account.
    <p>
    <a href='https://crimsonwebs.com/s270150/Gadgetou/php/verify_account.php?email=".$user_email."&key=".$otp."'
    >Click Here to reactivate your account</a>";
    
    $mail->setFrom($from,"Gadgetou");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

function random_password($length){
    // Collection of elements
		$chars = array('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 
		'i', 'j', 'k', 'l','m', 'n', 'o', 'p', 'q', 'r', 's', 
		't', 'u', 'v', 'w', 'x', 'y','z', 'A', 'B', 'C', 'D', 
		'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L','M', 'N', 'O', 
		'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y','Z', 
		'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '!', 
		'@','#', '$', '%', '^', '&', '*', '(', ')', '-', '_', 
		'[', ']', '{', '}', '<', '>', '~', '`', '+', '=', ',', 
		'.', ';', ':', '/', '?', '|');
 
	// In the $chars randomly catch $length * elements
		$keys = array_rand($chars, $length); 
 
		$password = '';
		
		for($i = 0; $i < $length; $i++){
		    
			//put $length * element together
			$password .= $chars[$keys[$i]];
		}
 
		return $password;
}
?>