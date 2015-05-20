<?php 

    include_once 'dbInfo.php';
    $newdb = 'vishzlkf_pastedump';
    $message = $_POST;
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
            echo "here";
    }else{
        $query = "SELECT * FROM pastebin WHERE id = $id";    
    }

    echo $code;

    $r = mysql_query($query);
    

    if ($code != 1){
        while ($response = mysql_fetch_assoc($r)){
        $output[] = $response;
        }
        if (is_null($output)){
            $data = array("id" => "NOT GOOD", "paste" => "NOT HAPPENING", "response" => 100);
            echo json_encode($data);
        }else{

            echo json_encode($output);
        }
    }

    mysql_close();

    

?>