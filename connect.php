<?php
    function connect()
    {
        session_start(["use_strict_mode" => true]);
        $host = 'localhost';
        $port = 5434;   
        $dbname = 'CodeDay';
        $username = 'postgres';
        $password = '123';
        $conn_string = "host=localhost port=5434 dbname=CodeDay user=postgres password=123";
        $dbconn = pg_connect($conn_string);

        return $dbconn;
    }
?>