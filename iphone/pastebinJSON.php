<?php 

    include_once 'dbInfo.php';
    header('Content-Type: application/json');
    $newdb = 'vishzlkf_pastedump';
    $message;    
    /*if ($headers["Content_Type"] == "application/json"){
        $message = json_decode($_POST);
    }else{
        $message = $_POST;    
    }*/
    $message = json_decode(file_get_contents('php://input'), true);

    $id = $message['id'];
    $code = $message['code'];
    $paste = $message['paste'];
    $output;
    $query;
    mysql_connect(localhost, $username, $password);
    @mysql_select_db($newdb) or die ("Unable to find database");


    if ($code == 1){
        $query = "INSERT INTO `pastebin` (id, paste, date) 
            VALUES('$id', '$paste', NOW()) ON DUPLICATE KEY UPDATE paste=VALUES(paste), date=VALUES(date)";
    }else{
        $query = "SELECT * FROM pastebin WHERE id = $id";    
    }

    $r = mysql_query($query);
    

    if ($code != 1){
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

            echo json_encode($output);
        }
    }

    mysql_close();

    

?>