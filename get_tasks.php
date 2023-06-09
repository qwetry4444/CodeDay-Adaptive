<?php
    function get_tasks($dbconn)
    {
        $query_task = 'SELECT * FROM "CodeDay".tasks';
        $result_task = pg_query($dbconn, $query_task);
        $tasks = pg_fetch_all($result_task);

        return $tasks;
    }

    function get_task_statistics($dbconn, $task, $id_statistics)
    {
        $query_task_statistics = 'SELECT * FROM "CodeDay".task_statistics WHERE "CodeDay".task_statistics.id_statistics = %d';
        $query_task_statistics = sprintf($query_task_statistics, $task['id_statistics']);

        $result_task_statistics = pg_query($dbconn, $query_task_statistics);
        $task_statistics_array = pg_fetch_all($result_task_statistics);

        return $task_statistics_array;
    }

    function get_full_task($dbconn, $id)
    {
        $sql = 'SELECT * FROM "CodeDay".tasks  LEFT JOIN "CodeDay".task_statistics ON "tasks"."id_statistics"="task_statistics"."id_statistics" WHERE id=%d';
        $sql = sprintf($sql, $id);
        $query_result_full_task = pg_query($dbconn, $sql);
        $full_task = pg_fetch_array($query_result_full_task);
        return $full_task;
    }
    
?> 