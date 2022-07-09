<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$name = $_GET['name'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
    $status = "Paid";
}else{
    $paidstatus = "Failed";
    $status = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-ANIvHnjnZAiGe-MYFl5Sxw');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
        $sqlinsertpayment = "INSERT INTO `tbl_orders`( `user_email`,`receipt_id`, `amount_paid`,`order_status`) VALUES ('$email','$receiptid','$amount','$status')";
        $sqpupdatecart = "UPDATE `tbl_carts` SET `cart_status`='paid',`receipt_id`='$receiptid' WHERE user_email='$email' AND cart_status IS NULL";
        if ($conn->query($sqlinsertpayment) && $conn->query($sqpupdatecart)){
            $sqlselectcart="SELECT * FROM tbl_carts WHERE receipt_id = '$receiptid'";
            $result = $conn->query($sqlselectcart);
            $message = "Payment completed. Return back to the application by pressing the back button on the app task bar.";
            $amount = number_format((float)$amount, 2, '.', '');
            printTable($receiptid,$name,$email,$amount,$paidstatus,$message);   
        }else{
            $message = "Payment incompleted. Return back to the application by pressing the back button on the app task bar and perform the payment again.";
            printTable('Failed',$name,$email,$amount,$paidstatus,$message);
        }
    }else{
        $message = "Payment incompleted. Return back to the application by pressing the back button on the app task bar and perform the payment again.";
        printTable('Failed',$name,$email,$amount,$paidstatus,$message);
    }
}

function printTable($receiptid,$name,$email,$amount,$paidstatus,$message){
   echo "
        <html>
        <head>
            <meta name='viewport' content='width=device-width, initial-scale=1'>
            <link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
        </head>
        <div = class='w3-padding'> <h4>Thank you for your payment</h4>
        <p>The following is your receipt</p></div>
        <div class='w3-container w3-padding'>
            <table class='w3-table w3-striped w3-bordered'>
            <tr><th>Receipt ID</th><td>$receiptid<td></tr>
            <tr><th>Paid By</th><td>$name<td></tr>
            <tr><th>Email</th><td>$email<td></tr>
            <tr><th>Amount </th><td>RM $amount<td></tr>
            <tr><th>Payment Status</th><td>$paidstatus<td></tr>
            </table>
        <hr>
        <div class='w3-container w3-round w3-block w3-green'>$message</div>
        </div>
        </body></html> 
        ";
}

?>