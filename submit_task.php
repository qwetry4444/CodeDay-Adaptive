<?php
    require('connect.php');
    require('decision_process.php');

    $db_conn = connect();
    session_start(["use_strict_mode" => true]);
    $task_id = $_GET['task_id'];
    $pl = $_POST['pl'];
    $code = $_POST['program_code'];   

    if(isset($_SESSION['user_id']))
    {
        $user_id = $_SESSION['user_id'];
        if(decision_process_exists($db_conn, $user_id, $task_id) == 'f')
        {
            create_decision_process($db_conn, $user_id, $task_id, $code, $pl);
        }
        else
        {
           update_decision_process($db_conn, $user_id, $task_id, $code, $pl);
        }
    }
    else
    {
        header("Location: pages/main.php?page=login");
    }

    $task_link = sprintf('Location: pages/task.php?task_id=%d', $task_id);
    header($task_link);

?>