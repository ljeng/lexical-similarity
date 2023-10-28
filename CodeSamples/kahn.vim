function! Kahn(graph, n)
    let inverse = {}
    for u in range(n)
        for v in a:graph[u]
            call add(inverse[v], u)
        endfor
    endfor
    let stack = []
    for v in range(n)
        if empty(inverse[v])
            call add(stack, v)
        endif
    endfor
    let order = []
    while !empty(stack)
        let u = remove(stack, -1)
        call add(order, u)
        for v in copy(a:graph[u])
            call remove(a:graph[u], index(a:graph[u], v))
            call remove(inverse[v], index(inverse[v], u))
            if empty(inverse[v])
                call add(stack, v)
            endif
        endfor
    endwhile
    if len(order) != a:n
        return 'Cyclic graph'
    else
        return order
    endif
endfunction

function! ReadInput()
    let input_file = 'input.txt'
    let output_file = 'output.txt'
    let input_lines = readfile(input_file)
    let t = str2nr(remove(input_lines, 0))
    let cases = input_lines[1:]
    let current_line = 0
    for i in range(t)
        let n = str2nr(remove(cases, 0))
        let current_line += 1
        let graph = {}
        while 1
            let line = cases[0]
            if empty(line)
                break
            endif
            let parts = split(line)
            let u = str2nr(get(parts, 0, '0'))
            let v = str2nr(get(parts, 1, '0'))
            if !has_key(graph, u)
                let graph[u] = []
            endif
            call add(graph[u], v)
            let current_line += 1
            call remove(cases, 0)
        endwhile
        let result = Kahn(graph, n)
        if result == 'Cyclic graph'
            call append(current_line, 'Cyclic graph')
        else
            call append(current_line, join(result, ' '))
        endif
        let current_line += 1
    endfor
    call writefile(cases, output_file)
endfunction

call ReadInput()
