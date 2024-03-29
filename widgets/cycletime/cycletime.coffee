class Dashing.Cycletime extends Dashing.Widget
  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    cycleTimes = @get('cycleTimes')
    if cycleTimes
      cycleTimes[cycleTimes.length - 1].y

  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    

    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: @get("graphtype")
      series: [
        {
        color: "#fff",
        data: [{x:0, y:0}]
        }
      ]
    )

    @graph.series[0].data = @get('cycleTimes') if @get('cycleTimes')
    @x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph, ticksTreatment:'glow')
    @y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()
    @x_axis.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.cycleTimes
      @graph.render()


