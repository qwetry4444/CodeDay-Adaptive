<?php
function exit(){
    session_start(["use_strict_mode" => true]);
    $_SESSION['id'] = NULL;
    $_SESSION['username'] = NULL;
}
?>