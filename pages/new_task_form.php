
<div class="container">
    <div class="add_new_task_form_box">
        <form method="post" action="../add_new_task.php">
            <h2>Create new task</h2>
            <div class="input-box">
            <input type="text" name="task_name" required>
                <label for="">Task name</label>
            </div>
            <div class="input-box">
            <input type="text" name="topic" required>
                <label for="">Topic</label>
            </div>
            <div class="input-box">
                <input type="text" name="complexity" required>
                <label for="">Complexity</label> 
            </div>
            <div class="input-box">
                <textarea name="description" cols="34" rows="10"></textarea>
                <label for="">Description</label>
            </div>
            <button type="Submit">Add new Task</button>
        </form>
        <?php
        if (isset($_SESSION['message']))
        {
            session_start(["use_strict_mode" => true]);
            echo ("<div class='session_message'>".$_SESSION['message']."</div>");
            unset($_SESSION['message']);
        }
        ?>
    </div>
</div>