<?php
    function echo_task()
    {
        <div class="row">
        <div class="col-1">
            <?php
            echo $task['number'];
            ?>
        </div>
        <div class="col-2">
            <?php
            echo $task['task_name'];
            ?>
        </div>
        <div class="col-1">
            <?php
            echo $task['topic'];
            ?>
        </div>
        <div class="col-1">
            <?php
            echo $task['complexity'];
            ?>
        </div>

        <div class="col-1">
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
    }

?>