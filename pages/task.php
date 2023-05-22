<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="css/style_header.css">
    <link rel="stylesheet" href="css/style_tasks.css">
    <title>CodeDay Task</title>
</head>

<?php
    require('header.php');
    require('connect.php');
    require('get_tasks.php');
    $db_conn = connect();

    $task = get_full_task($db_conn, $_GET['task_num']);

?>
<body>
    <div class="task_container">
        <div class="row task_about-solving">
            <div class="col-sm-5 task_about">
                <div class="row">
                    <div class="col-12">
                        <h2><b><?php echo $task['number']?>.<?php echo $task['task_name']?></b></h2>
                    </div>
                </div>

                <div class="row">
                    <div class="col-6">
                        <h3 class="topic">Topic: <?php echo $task['topic']?></h3>
                        
                    </div>
                    <div class="col-6">
                        <h3 class="complexity">Complexity: <?php echo $task['complexity']?></h3>
                    </div>
                </div>

                <div class="row">
                    <h3>Description.</h3></b>
                    <p><?php echo $task['description']?></p>
                </div>
                <div class="row">
                    <h3>Task statistic</h3>
                </div>
                <div class="row">
                    <div class="col-4">
                        <h4 >Number of attempts: <?php echo $task['count_try']?></h4>
                    </div>
                    <div class="col-4">
                        <h4>Number of successful attempts: <?php echo $task['count_successful_try']?></h4>
                    </div>    
                    <div class="col-4">
                        <h4>Solvability percentage: <?php echo $task['solvability_percentage']?>%</h4>
                    </div>
                </div>

                <div class="row">
                    <div class="col-6">
                        <img src="img/like.png" alt="like" class="like">
                        <h4>Count likes: <?php echo $task['count_like']?></h4>
                    </div>
                    <div class="col-6">
                        <img src="img/dislike.png" alt="dislike" class="dislike">
                        <h4>Count dislikes: <?php echo $task['count_dislike']?></h4>
                    </div>
                </div>

            </div>
            <div class="col-5 task_solving">
                <div class="select_pl">
                    <select name="" id="">
                        <option selected disabled>Select PL</option>
                        <option value="1">Python</option>
                        <option value="2">C</option>
                        <option value="3">C++</option>
                    </select>
                </div>
                <form action="">
                    <textarea name="" id="" cols="80" rows="29" class="code_field"></textarea>
                    <div class="submit_block">
                        <button type="sumbit" class="submit_task">Submit</button>
                    </div>
                </form>
            </div>
            
        </div>
    </div>
</body>
</html>



