<?php 

    include_once 'dbInfo.php';
    header('Content-Type: application/json');
    $newdb = 'vishzlkf_pastedump';
    $message = $_POST;
    $id = $message['id'];
    $pass = $message['password'];
    $output;
    $query;
    mysql_connect(localhost, $username, $password);
    @mysql_select_db($newdb) or die ("Unable to find database");
        
    if ($code == 0){
        $query = "SELECT COUNT(1) FROM pastebin WHERE id = '$id'";
    }

    $r = mysql_query($query);

     while ($response = mysql_fetch_assoc($r)){
        $output[] = $response;
    }

    if (mysql_fetch_array($r)[0] == 0){
        $query = "INSERT INTO `pastebin` (id, password) VALUES('$id', '$pass')";
        mysql_query($query);
    }

     echo json_encode($output); 

    mysql_close();
?>