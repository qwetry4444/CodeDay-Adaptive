<?php
    function connect()
    {
        $host = 'localhost';
        $port = 5434;   
        $dbname = 'CodeDay';
        $username = 'postgres';
        $password = '123';
        $conn_string = "host='%s' port=%d dbname='%s' user='%s' password=%d";
        $conn_string = sprintf($conn_string, $host, $port, $dbname, $username, $password);
        $dbconn = pg_connect($conn_string);
        
        return $dbconn;
    }
?>