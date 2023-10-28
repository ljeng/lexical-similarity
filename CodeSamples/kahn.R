kahn <- function(graph, n) {
  inverse <- vector("list", n)
  for (u in 1:n) {
    for (v in graph[[u]]) {
      inverse[[v]] <- c(inverse[[v]], u)
    }
  }
  stack <- which(sapply(inverse, length) == 0)
  order <- integer(0)
  while (length(stack) > 0) {
    u <- stack[length(stack)]
    stack <- stack[-length(stack)]
    order <- c(order, u)
    for (v in graph[[u]]) {
      graph[[u]] <- graph[[u]][-which(graph[[u]] == v)]
      inverse[[v]] <- inverse[[v]][-which(inverse[[v]] == u)]
      if (length(inverse[[v]]) == 0) {
        stack <- c(stack, v)
      }
    }
  }
  if (length(order) != n) {
    return("Cyclic graph")
  }
  return(order)
}

read_input <- function() {
  lines <- readLines("input.txt")
  t <- as.integer(lines[1])
  lines <- lines[-1]
  cases <- list()
  for (i in 1:t) {
    n <- as.integer(lines[1])
    lines <- lines[-1]
    graph <- list()
    while (length(lines) > 0) {
      line <- strsplit(lines[1], " ")[[1]]
      lines <- lines[-1]
      u <- as.integer(line[1])
      v <- as.integer(line[2])
      if (!exists(u, envir = graph)) {
        graph[[u]] <- list()
      }
      graph[[u]] <- c(graph[[u]], v)
    }
    cases[[i]] <- list(n = n, graph = graph)
  }
  return(list(t = t, cases = cases))
}

main <- function() {
  input <- read_input()
  output <- file("output.txt", "w")
  for (i in 1:input$t) {
    result <- kahn(input$cases[[i]]$graph, input$cases[[i]]$n)
    if (result == "Cyclic graph") {
      cat("Cyclic graph\n", file = output)
    } else {
      cat(paste(result, collapse = " "), "\n", file = output)
    }
  }
  close(output)
}

main()
