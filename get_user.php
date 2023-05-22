<?php
function get_full_user($db_conn, $id)
{
    session_start(["use_strict_mode" => true]);
    $sql = 'SELECT * FROM "CodeDay".users LEFT JOIN "CodeDay".user_progress ON "CodeDay".users.id_progress = "CodeDay".user_progress.id WHERE "CodeDay".users.id = %d';
    $sql = sprintf($sql, $_SESSION['user_id']);
    $result_query = pg_query($db_conn, $sql);
    $full_user = pg_fetch_array($result_query);
    
    return $full_user;
}
?>