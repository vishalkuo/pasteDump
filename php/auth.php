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
        
    $query = "SELECT * FROM pastebin WHERE id = '$id'";

    $r = mysql_query($query);

     while ($response = mysql_fetch_assoc($r)){
        $output[] = $response;
    }

    while ($response = mysql_fetch_assoc($r)){
    $output[] = $response;
    }
    if (is_null($output)){
        $data = array("id" => "$id", "paste" => "NOT HAPPENING", "response" => 100, "query" => "$query",
            "code" => "$code");
        echo "[";
        echo json_encode($data); 
        echo "]";
    }else{
        if($output['password'] == $password){
            $data = array("id" => "$id", "paste" => "NOT HAPPENING", "response" => 0, "query" => "$query",
            "code" => "$code");
        echo "[";
        echo json_encode($data); 
        echo "]";
        }
    }


    mysql_close();
?>