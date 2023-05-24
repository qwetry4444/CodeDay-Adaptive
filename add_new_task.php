<?php
require('connect.php');
$db_conn = connect();
session_start(["use_strict_mode" => true]);

$task_name = $_POST['task_name'];
$task_topic = $_POST['topic'];
$task_complexity = $_POST['complexity'];
$task_description = $_POST['description'];

$sql = "INSERT INTO \"CodeDay\".tasks(
        number, task_name, topic, complexity, description)
        VALUES(10, '%s', '%s', '%s', '%s')";
$sql = sprintf($sql, $task_name, $task_topic, $task_complexity, $task_description);
$result = pg_query($db_conn, $sql);

if($result)
    $_SESSION['message'] = 'Ваша задача успешно добавлена';
else
    $_SESSION['message'] = $sql;

header("Location: pages/main.php?page=new_task_form");

?>