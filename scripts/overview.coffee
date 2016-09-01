ReportTab = require 'reportTab'
templates = require '../templates/templates.js'
_partials = require '../node_modules/seasketch-reporting-api/templates/templates.js'

partials = []
for key, val of _partials
  partials[key.replace('node_modules/seasketch-reporting-api/', '')] = val
d3=window.d3

class OverviewTab extends ReportTab
  name: 'Overview'
  className: 'overview'
  template: templates.overview
  dependencies: [
    'DesignatedAreasToolbox'
  ]
  render: () ->
    # pull data from GP script
    areas = @recordSet('DesignatedAreasToolbox', 'DesignatedAreas').toArray()
    @roundData areas

    if areas?.length > 0
      desc = areas[0].DESC_
    else
      desc = "No description given"

    # setup context object with data and render the template from it
    context =
      sketch: @model.forTemplate()
      sketchClass: @sketchClass.forTemplate()
      attributes: @model.getAttributes()
      admin: @project.isAdmin window.user
      areas: areas
      DESC: desc
    
    @$el.html @template.render(context, templates)
    @enableLayerTogglers()
    @enableTablePaging()

  roundData: (data) =>
    for d in data
      try
        d.AREA_SQKM = parseFloat(d.AREA_SQKM).toFixed(2)
      catch
        d.AREA_SQKM = 0.0

module.exports = OverviewTab