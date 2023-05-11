<?php
    require('connect.php');
    $db_conn = connect();

    $sql = 'SELECT * FROM "CodeDay"."tasks" WHERE id = 1';
    $query = pg_query($db_conn, $sql);
    $task = pg_fetch_one($query);
    echo($task['number']);

?>