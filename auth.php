<?php

session_start(["use_strict_mode" => true]);
if(isset($_POST['login']))
{
    include('connect.php');
    $db_conn = connect();
    $sql = "SELECT * FROM \"CodeDay\".users WHERE email = '%s'";
    $sql = sprintf($sql, $_POST['login']);
    $result = pg_query($db_conn, $sql);

    if($row = pg_fetch_array($result))
    {
        print_r($row);
        if(MD5($_POST["password"]) == $row['password'])
        {
            $_SESSION['username'] = $_POST['login'];
            $_SESSION['user_id'] = $row['id'];
            $_SESSION['message'] = 'Вы успешно вошли в сиситему';
            echo("123");
            header("Location: pages/main.php?page=home");
            die();
        }
        else 
        {
            $_SESSION['message'] = 'Вы ввели неправильный пароль!';
            echo $_SESSION['message'];
            header("Location: pages/main.php?page=login");
            echo $_SESSION['message'];
            die();
        }
    }
    else 
    {
        $_SESSION['message'] = 'Вы ввели неправильный логин!';
        echo $_SESSION['message'];
        header("Location: pages/main.php?page=login");
        die();
    }
}   

if ($_GET['logout'] == 1){
        $_GET['logout'] = 1;
        unset($_SESSION['username']);
        unset($_SESSION['user_id']);
        $_SESSION['message'] = 'Вы успешно вышли из сиситемы';
        header("Location: pages/main.php?page=login");
        echo($_SESSION['username']);
        die();
    }
    
    header("Location: pages/main.php?page=login");
    die();
?>