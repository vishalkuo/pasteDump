<?php 

    include_once 'dbInfo.php';
    $newdb = 'vishzlkf_pastedump';
    $message = $_POST;
    $id = $message['id'];
    $code = $message['code'];
    $output;

    mysql_connect(localhost, $username, $password);
    @mysql_select_db($newdb) or die ("Unable to find database");


    $query = "SELECT * FROM pastebin WHERE id = $id";

    $r = mysql_query($query);
    while ($response = mysql_fetch_assoc($r)){
        $output[] = $response;
    }


    if (is_null($output)){
        $data = array("id" => "NOT GOOD", "paste" => "NOT HAPPENING");
        echo json_encode($data);
    }else{
        //print $output[0]['paste'];
        echo json_encode($output);
    }

    mysql_close();

    

?>