<?php
$file = '/var/www/wordpress/wp-content/themes/twentytwentyfour/patterns/testimonial-centered.php';
$content = file_get_contents($file);
$search = '<em>“Études has saved us thousands of hours of work and has unlocked insights we never thought possible.”</em>';
$replace = '<em>“Inception was a cool project to spend hours working on and has unlocked insights we never thought possible.”</em>';
$content = str_replace($search, $replace, $content);
file_put_contents($file, $content);
?>