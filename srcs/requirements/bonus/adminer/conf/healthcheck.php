<?php
$host = getenv('FPM_HOST') ?: '127.0.0.1';
$port = intval(getenv('FPM_PORT') ?: '9000');

$sock = @fsockopen($host, $port, $errno, $errstr, 2.0);
if (!$sock) {
    fwrite(STDERR, "connect failed: $errstr ($errno)\n");
    exit(1);
}

// Send minimal FCGI request for ping path
fclose($sock);
exit(0);