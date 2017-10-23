MARGIN = 100

svg = d3.select('svg')
width = svg.node().getBoundingClientRect().width
height = svg.node().getBoundingClientRect().height

keys = ["Atlanta","Chicago","Denver","Houston","Los Angeles","Miami","New York","San Francisco","Seattle","Washington, DC"]

m = [[0,587,1212,701,1936,604,748,2139,2182,543],
[587,0,920,940,1745,1188,713,1858,1737,597],
[1212,920,0,879,831,1726,1631,949,1021,1494],
[701,940,879,0,1374,968,1420,1645,1891,1220],
[1936,1745,831,1374,0,2339,2451,347,959,2300],
[604,1188,1726,968,2339,0,1092,2594,2734,923],
[748,713,1631,1420,2451,1092,0,2571,2408,205],
[2139,1858,949,1645,347,2594,2571,0,678,2442],
[2182,1737,1021,1891,959,2734,2408,678,0,2329],
[543,597,1494,1220,2300,923,205,2442,2329,0]]

points_data = mds_classic(m)
min_x = d3.min points_data, (d) -> d[0]
max_x = d3.max points_data, (d) -> d[0]
min_y = d3.min points_data, (d) -> d[1]
max_y = d3.max points_data, (d) -> d[1]

x = d3.scale.linear()
  .domain([max_x, min_x])
  .range([MARGIN, width-MARGIN])
  
y = d3.scale.linear()
  .domain([min_y, max_y])
  .range([MARGIN, height-MARGIN])
  
# links

links_data = []
points_data.forEach (p1,i1) ->
  array = []
  points_data.forEach (p2,i2) ->
    if i1 isnt i2
      array.push {source: p1, target: p2, dist: m[i1][i2]}
  links_data = links_data.concat array

links = svg.selectAll('.link')
  .data(links_data)
  
links.enter().append('line')
  .attr
    class: 'link'
    x1: (d) -> x(d.source[0])
    y1: (d) -> y(d.source[1])
    x2: (d) -> x(d.target[0])
    y2: (d) -> y(d.target[1])

# points

points = svg.selectAll('.point')
  .data(points_data)
  
enter_points = points.enter().append('g')
  .attr
    class: 'point'
    transform: (d) -> "translate(#{x(d[0])},#{y(d[1])})"
    
enter_points.append('circle')
  .attr
    r: 6
    opacity: 0.3
    
enter_points.append('circle')
  .attr
    r: 4
    
enter_points.append('text')
  .text (d,i)-> keys[i]
  .attr
    y: 12
    dy: '0.35em'
    
enter_points.append('title')
  .text (d,i) -> "#{d[0]}, #{d[1]}"
  
# distance indicators

indicators = svg.selectAll('.indicator')
  .data(links_data)
  
indicators.enter().append('circle')
  .attr
    class: 'indicator'
    r: 5
    cx: (d) ->
      mul = d.dist / Math.sqrt( Math.pow(d.target[1]-d.source[1],2) + Math.pow(d.target[0]-d.source[0],2) )
      return x(d.source[0]) + mul*(x(d.target[0])-x(d.source[0]))
    cy: (d) ->
      mul = d.dist / Math.sqrt( Math.pow(d.target[1]-d.source[1],2) + Math.pow(d.target[0]-d.source[0],2) )
      return y(d.source[1]) + mul*(y(d.target[1])-y(d.source[1]))
      
# interaction

enter_points
  .on 'click', (d) ->
    links.classed 'visible', (l) -> l.source is d
    indicators.classed 'visible', (l) -> l.source is d