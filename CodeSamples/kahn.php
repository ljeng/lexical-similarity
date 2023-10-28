<?php

function kahn($graph, $n) {
    $inverse = [];
    foreach ($graph as $u => $neighbors) {
        foreach ($neighbors as $v) {
            $inverse[$v][] = $u;
        }
    }

    $stack = array_filter(range(0, $n - 1), function ($v) use ($inverse) {
        return !isset($inverse[$v]);
    });

    $order = [];

    while (!empty($stack)) {
        $u = array_pop($stack);
        $order[] = $u;

        $neighborList = array_values($graph[$u]);

        foreach ($neighborList as $v) {
            unset($graph[$u][$v]);
            $key = array_search($v, $inverse[$v]);
            if ($key !== false) {
                unset($inverse[$v][$key]);
            }

            if (empty($inverse[$v])) {
                array_push($stack, $v);
            }
        }
    }

    if (count($order) !== $n) {
        return 'Cyclic graph';
    }

    return $order;
}

$inputFile = fopen('input.txt', 'r');
$outputFile = fopen('output.txt', 'w');

$t = (int)fgets($inputFile);
while ($t--) {
    $n = (int)fgets($inputFile);
    $graph = [];

    while (true) {
        $line = trim(fgets($inputFile));
        if (!empty($line)) {
            [$u, $v] = explode(' ', $line);
            $u = (int)$u;
            $v = (int)$v;

            if (!isset($graph[$u])) {
                $graph[$u] = [];
            }

            $graph[$u][] = $v;
        } else {
            $output = kahn($graph, $n);

            if ($output === 'Cyclic graph') {
                fwrite($outputFile, "Cyclic graph\n");
            } else {
                fwrite($outputFile, implode(' ', $output) . "\n");
            }

            break;
        }
    }
}

fclose($inputFile);
fclose($outputFile);
?>
