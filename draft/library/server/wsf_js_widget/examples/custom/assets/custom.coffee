class WSF_BARCHART_CONTROL extends WSF_CONTROL
	requirements: ['/assets/d3.min.js', '/assets/graph.css']

	attach_events: ()->
		super
		margin =
			top: 20
			right: 20
			bottom: 30
			left: 40

		#Clear
		@$el.html("")
		#Calculate width
		width = @$el.width() - margin.left - margin.right
		height = 500 - margin.top - margin.bottom
		#Create axis
		x = d3.scale.ordinal().rangeRoundBands([
			0
			width
		], .1)
		y = d3.scale.linear().range([
			height
			0
		])
		@xAxis = d3.svg.axis().scale(x).orient("bottom")
		@yAxis = d3.svg.axis().scale(y).orient("left").ticks(10)
		svg = d3.select(@$el[0]).append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")")
		
		#Store svg, x and y scale in class so we can update the domain if a callback occures
		@x = x
		@y = y
		@svg = svg
		@height = height
		@xAxis_container = svg.append("g")
			.attr("class", "x axis")
			.attr("transform", "translate(0," + height + ")")
		@yAxis_container = svg.append("g")
			.attr("class", "y axis")
		#Call build graph to load the graph data
		@updatechart()

	updatechart: ()->
		height = @height
		data = @state.data
		x = @x
		y = @y
		#Set domain
		x.domain data.map((d) ->
			d.key
		)
		y.domain [
			0
			d3.max(data, (d) ->
				d.value
			)
		]
		#Update axis
		@xAxis_container.transition().duration(1000).call @xAxis
		@yAxis_container.transition().duration(1000).call @yAxis
		#Map data
		rect = @svg.selectAll(".bar")
			.data(data, (d)-> d.key)
		#Add new bars
		rect.enter()
				.insert("rect")
					.attr("class", "bar")
					.attr("x", (d) ->
						x d.key
					)
					.attr("width", x.rangeBand())
					.attr("y", (d) ->
						height
					)
					.attr "height", (d) ->
						0
		#Adjust bar positions and sizes
		rect.transition().duration(1000).attr("x", (d) ->
				x d.key
			)
			.attr("width", x.rangeBand())
			.attr("y", (d) ->
				y d.value
			)
			.attr "height", (d) ->
				height - y(d.value)
		#Animate exiting bars
		rect.exit().transition().duration(1000)
			.style('opacity', 0)
			.attr("height", (d) ->
				0
			).attr("y", (d) ->
				height
			).remove()
			
	update: (state) ->
		if state.data != undefined
			@state['data'] = state.data
			data = state.data
			@updatechart()