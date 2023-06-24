<?php
    function update_evaluation($db_conn, $user_id, $task_id, $type){
        $result_evaluation = pg_query_params($db_conn, "INSERT INTO \"CodeDay\".evaluation(
            user_id, task_id, type)
            VALUES ($1, $2, $3);", array($user_id, $task_id, $type));
        
        // $result_task_statistics = pg_query_params("UPDATE \"CodeDay\".task_statistics
        //     SET count_dislike=(count_dislike + 1)
        //     WHERE (SELECT id FROM \"CodeDay\".tasks WHERE tasks.id_statistics = task_statistics.id_statistics)=$1;", array($task_id));
        if($type == 0)
        {
            $result_task_statistics = pg_query_params("UPDATE \"CodeDay\".task_statistics
            SET count_dislike=(count_dislike + 1)
            WHERE (SELECT id FROM \"CodeDay\".tasks WHERE tasks.id_statistics = task_statistics.id_statistics)=$1;", array($task_id));
        }
        else if($type == 1)
        {
            $result_task_statistics = pg_query_params("UPDATE \"CodeDay\".task_statistics
            SET count_like=(count_like + 1)
            WHERE (SELECT id FROM \"CodeDay\".tasks WHERE tasks.id_statistics = task_statistics.id_statistics)=$1;", array($task_id)); 
        }
    }
    
    function estimation_exists($db_conn, $user_id, $task_id){
        $result = pg_query_params($db_conn, "SELECT EXISTS(SELECT user_id FROM \"CodeDay\".evaluation WHERE user_id = $1 AND task_id = $2)", array($user_id, $task_id));
        $data = pg_fetch_array($result);
        $exists = $data['exists'];

        return $exists;
    }

?>

