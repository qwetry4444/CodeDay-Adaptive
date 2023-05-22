
<?php
    include '../connect.php';
    include '../get_tasks.php';
?>

    <div class="container_tasks">
        <div class="row task task_menu">
            <div class="col-1">Number</div>
            <div class="col-3">Title</div>
            <div class="col-2">Topic</div>
            <div class="col-2">Complexity</div>
            <div class="col-2">Solvability %</div>
            <div class="col-1"><img src="../img/like_white.png" alt="like" class="like"></div>
            <div class="col-1"><img src="../img/dislike_white.png" alt="dislike" class="dislike"></div>
        </div>

        <div class="tasks">
            <?php
                $dbconn = connect();

                $tasks = get_tasks($dbconn);

                foreach($tasks as $task)
                {
                    $task_statistics = get_task_statistics($dbconn, $task, 1);
                    $task_id = $task['id'];
                    $task_link = sprintf('task.php?task_num=%d', $task_id);
            ?>

            <?php echo("<a href=$task_link>") ?>
                <div class="row task">
                    <div class="col-1">
                        <?php
                        echo $task['number'];
                        ?>
                    </div>
                    <div class="col-3">
                        <?php
                        echo $task['task_name'];
                        ?>
                    </div>
                    <div class="col-2">
                        <?php
                        echo $task['topic'];
                        ?>
                    </div>
                    <div class="col-2">
                        <?php
                        echo $task['complexity'];
                        ?>
                    </div>

                    <div class="col-2">
                        <?php
                        echo $task_statistics[0]['solvability_percentage'];
                        ?>
                    </div>

                    <div class="col-1">
                        <?php
                        echo $task_statistics[0]['count_like'];
                        ?>
                    </div>

                    <div class="col-1">
                        <?php
                        echo $task_statistics[0]['count_dislike'];
                        ?>
                    </div>
                </div>
            </a>
<?php
    }
?>
        </div>
    </div>




