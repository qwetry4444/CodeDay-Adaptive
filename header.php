
<header>
    <div class="container">
        <nav class="navbar navbar-expand-lg">
            <div class="container-fluid">
                <a class="navbar-brand logo" href="main.php?page=home">CodeDay
                    <img src="img/logo.png" alt="Logo">
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <img src="img/list.svg" alt="Menu button" class="burger_icon">
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav menu">
                        <li class="nav-item">
                            <a href="main.php?page=home" class="nav-link">Home</a>
                        </li>
                        <li class="nav-item">
                            <a href="main.php?page=tasks" class="nav-link">Tasks</a>
                        </li> 
                        <li class="nav-item">
                            <a href="main.php?page=statistic" class="nav-link">My statistic</a>
                        </li>

                        <?php
                            if (isset($_SESSION['username']))
                            {
                                echo ("<li class='nav-item'><a hreh='main.php?page=profile'> My profile </a></li>");
                            }
                            else echo("<li class='nav-item'><a href='main.php?page=login' class='nav-link'>Login</a></li>");
                        ?>
                    </ul>
                </div>
            </div>
        </nav>
    </div>
</header>