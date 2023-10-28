function Kahn-Algorithm {
    param (
        [hashtable] $graph,
        [int] $n
    )

    $inverse = @{}
    for ($u = 0; $u -lt $n; $u++) {
        foreach ($v in $graph[$u]) {
            $inverse[$v] += $u
        }
    }

    $stack = @()
    0..($n - 1) | ForEach-Object {
        if (-not $inverse[$_]) {
            $stack += $_
        }
    }

    $order = @()
    while ($stack) {
        $u = $stack[-1]
        $stack = $stack[0..($stack.Length - 2)]
        $order += $u
        foreach ($v in $graph[$u]) {
            $graph[$u].Remove($v)
            $inverse[$v].Remove($u)
            if (-not $inverse[$v]) {
                $stack += $v
            }
        }
    }

    if ($order.Length -ne $n) {
        return "Cyclic graph"
    }

    return $order
}

function Main {
    $inputFile = Get-Content "input.txt"
    $outputFile = [System.IO.File]::CreateText("output.txt")

    $T = [int]($inputFile[0])
    $inputFile = $inputFile[1..($inputFile.Length - 1)]

    for ($i = 1; $i -le $T; $i++) {
        $n = [int]($inputFile[0])
        $inputFile = $inputFile[1..($inputFile.Length - 1)]

        $graph = @{}
        while ($inputFile[0]) {
            $line = $inputFile[0].Split(" ")
            $u = [int]($line[0])
            $v = [int]($line[1])
            if (-not $graph.ContainsKey($u)) {
                $graph[$u] = @()
            }
            $graph[$u] += $v
            $inputFile = $inputFile[1..($inputFile.Length - 1)]
        }

        $result = Kahn-Algorithm -graph $graph -n $n
        if ($result -eq "Cyclic graph") {
            $outputFile.WriteLine("Cyclic graph")
        } else {
            $outputFile.WriteLine($result -join " ")
        }
    }

    $outputFile.Close()
}

Main
