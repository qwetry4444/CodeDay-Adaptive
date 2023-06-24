<?php
    require('connect.php');
    $db_conn = connect();
    session_start(["use_strict_mode" => true]);

    $task_name = $_POST['task_name'];
    $task_topic = $_POST['topic'];
    $task_complexity = $_POST['complexity'];
    $task_description = $_POST['description'];
    $task_number = pg_fetch_array(pg_query($db_conn, "SELECT MAX(number) FROM \"CodeDay\".tasks"));

    $sql_task = "INSERT INTO \"CodeDay\".tasks(
            number, task_name, topic, complexity, description)
            VALUES(%d, '%s', '%s', '%s', '%s')";
    $sql_task = sprintf($sql_task, $task_number[0] + 1, $task_name, $task_topic, $task_complexity, $task_description);
    $result_task = pg_query($db_conn, $sql_task);

    $sql_procedure_add_stat = "CALL \"CodeDay\".add_id_stat('%s')";
    $sql_procedure_add_stat = sprintf($sql_procedure_add_stat, $task_name);
    $sql_procedure_add_stat_result = pg_query($db_conn, $sql_procedure_add_stat);

    if($sql_procedure_add_stat_result)
        $_SESSION['message'] = 'Ваша задача успешно добавлена';
    else
        $_SESSION['message'] = $sql_procedure_add_stat;

    header("Location: pages/main.php?page=new_task_form");
?>