<?php
    function decision_process_exists($db_conn, $user_id, $task_id){
        $result = pg_query_params($db_conn, "SELECT EXISTS(SELECT user_id FROM \"CodeDay\".decision_process WHERE user_id = $1 AND task_id = $2)", array($user_id, $task_id));
        $data = pg_fetch_array($result);
        $exists = $data['exists'];

        return $exists;
    }

    function create_decision_process($db_conn, $user_id, $task_id, $code, $pl){
        $result = pg_query_params($db_conn, "INSERT INTO \"CodeDay\".decision_process(
                                            user_id, task_id, programming_language, code)
                                            VALUES ($1, $2, $3, $4);", array($user_id, $task_id, $pl, $code));
        $data = pg_fetch_array($result);
    }

    function update_decision_process($db_conn, $user_id, $task_id, $code, $pl){
        $data_code = array('user_id'=>'%d', 'task_id'=>'%d', 'code'=>'%s');
        $data_code['user_id'] = sprintf($data_code['user_id'], $user_id);
        $data_code['task_id'] = sprintf($data_code['task_id'], $task_id);
        $data_code['code'] = sprintf($data_code['code'], $code);



        $data_condition = array('user_id'=>'%d', 'task_id'=>'%d');
        $data_condition['user_id'] = sprintf($data_condition['user_id'], $user_id);
        $data_condition['task_id'] = sprintf($data_condition['task_id'], $task_id);


        $res_code = pg_update($db_conn, 'CodeDay.decision_process', $data_code, $data_condition);
        if($res_code)
        {
            $data_pl = array('user_id'=>'%d', 'task_id'=>'%d','programming_language'=>'%s');
            $data_pl['user_id'] = sprintf($data_pl['user_id'], $user_id);
            $data_pl['task_id'] = sprintf($data_pl['task_id'], $task_id);
            $data_pl['programming_language'] = sprintf($data_pl['programming_language'], $pl);
            $res_pl = pg_update($db_conn, 'CodeDay.decision_process', $data_pl, $data_condition);
            return $res_pl;
        }
        else
            return 0;
    }

    function get_code($db_conn, $user_id, $task_id){
        if(decision_process_exists($db_conn, $user_id, $task_id) == 't')
        {
            $result = pg_query_params($db_conn, "SELECT code FROM \"CodeDay\".decision_process WHERE user_id = $1 AND task_id = $2", array($user_id, $task_id));
            $data = pg_fetch_array($result);
            $code = $data['code'];
            if($code)
                return $code;
            else
                return '';
        }
        else
            return '';
    }

    

?>