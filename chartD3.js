chart = {
  // Constants
  const width = 1344;
  const height = 840;
  // Attraction force between nodes (negative means repulsion force)
  const strength = -1000;
  const node_size = 10;
  // Restorative force after a node is released from drag
  const alpha_target = 0.3;
  const edge_opacity = 0.6;

  // Weight thresholds
  // Light thin dotted line
  const weight1 = 0.31;
  // Light thin dashed line
  const weight2 = 0.33;
  // Dark thin dashed line
  const weight3 = 0.357;
  // Dark thin solid line
  const weight4 = 0.39;
  // Dark thick solid line

  // Edge colors
  const light = "lightgray";
  const dark = "black";

  // Line weights
  const thin = 1;
  const thick = 3;

  // Dash patterns
  const dot_length = 2;
  const dot_spacing = 2;
  const dash_length = 6;
  const dash_spacing = 6;

  // Text distance from node
  const x = 8;
  const y = -8;

  /*
    Color scale
    Denim: systems programming
    Pumpkin: object-oriented programming
    Slimy green: computing
    Middle purple: functional programming
    Acid gold: dynamic
    Cerulean: scripting
  */
  const color = d3.scaleOrdinal(d3.schemeCategory10);
  color.domain(Array.from({ length: 10 }, (_, i) => i));

  // Read nodes
  const nodes = data.nodes.map(node => ({...node}));

  // Edges contain weak connections greater than weight4 and all strong connections
  const edges = data.strong_connections.map(edge => ({...edge}));
  edges.push(...data.weak_connections.filter(edge => edge.weight > weight4));

  // Create a simulation with several forces
  const simulation = d3.forceSimulation(nodes)
    .force("edge", d3.forceLink(edges).id(node => node.language))
    .force("charge", d3.forceManyBody().strength(strength))
    .force("center", d3.forceCenter(width / 2, height / 2))
    .on("tick", ticked);

  // Create the SVG container
  const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("viewBox", [0, 0, width, height])
      .attr("style", "max-width: 100%; height: auto;");

  // Draw a line for each edge
  const edge = svg.append("g")
    .attr("stroke-opacity", edge_opacity)
    .selectAll()
    .data(edges)
    .join("line")
    .each(function(edge) {
      d3.select(this)
        // Lexically similar pairs have darker edges
        .attr("stroke", edge.weight < weight2 ? light : dark)
        .attr("x1", edge.source.x)
        .attr("y1", edge.source.y)
        .attr("x2", edge.target.x)
        .attr("y2", edge.target.y)
        .attr("stroke-width", edge.weight < weight4 ? thin : thick)
        .attr("stroke-dasharray", () => {
          if (edge.weight < weight1) return `${dot_length},${dot_spacing}`;
          else if (edge.weight < weight3) return `${dash_length},${dash_spacing}`;
        });
    });
  
    // Draw a circle for each node
    const node = svg.append("g")
      .selectAll()
      .data(nodes)
      .join("g")
      .call(d3.drag().on("start", dragstarted).on("drag", dragged).on("end", dragended));
    node.append("circle")
        .attr("r", node => node_size * Math.sqrt(node.count))
        .attr("fill", node => color(node.component));
    node.append("title")
        .text(node => node.language);
    node.append("text")
        .text(node => node.language)
        .attr("x", x)
        .attr("y", y)
    node.call(d3.drag().on("start", dragstarted).on("drag", dragged).on("end", dragended));

  // Set the positions of the nodes each time the simulation moves
  function ticked() {
      edge
        .attr("x1", edge => edge.source.x)
        .attr("y1", edge => edge.source.y)
        .attr("x2", edge => edge.target.x)
        .attr("y2", edge => edge.target.y);
      node
        .attr("transform", edge => `translate(${edge.x},${edge.y})`);
  }

  // Fix the node position to the mouse when dragged
  function dragstarted(event) {
    if (!event.active) simulation.alphaTarget(alpha_target).restart();
    if (edges.some(edge => edge.source === event.subject || edge.target === event.subject)) {
      event.subject.fx = event.subject.x;
      event.subject.fy = event.subject.y;
    } else {
      simulation.force("center", null);
      simulation.force("charge", null);
    }
  }

  // Update the position of the node being dragged
  function dragged(event) {
    event.subject.fx = event.x;
    event.subject.fy = event.y;
  }

  // Unfix the node position to the mouse when drag ends
  function dragended(event) {
    if (!event.active) simulation.alphaTarget(0);
    if (edges.some(edge => edge.source === event.subject || edge.target === event.subject)) {
      event.subject.fx = null;
      event.subject.fy = null;
    } else {
      simulation.force("center", d3.forceCenter(width / 2, height / 2));
      simulation.force("charge", d3.forceManyBody().strength(strength));
    }
  }

  // Stop the previous simulation
  invalidation.then(() => simulation.stop());
  return svg.node();
}