<?php
    require('connect.php');
    require('update_evaluation.php');

    session_start(["use_strict_mode" => true]);

    $user_id = $_SESSION['user_id'];
    $task_id = $_GET['task_id'];
    $type = $_GET['type'];
    $db_conn = connect();
    echo($type);
    echo($type==true);
    echo($type==false);
    if(estimation_exists($db_conn, $user_id, $task_id) == 'f')
    {
        update_evaluation($db_conn, $user_id, $task_id, $type);
    }

    $task_link = sprintf('Location: pages/task.php?task_id=%d', $task_id);
    header($task_link);


?>