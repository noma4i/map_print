# MapPrint

[![Gem Version](https://badge.fury.io/rb/map_print@2x.png)](https://badge.fury.io/rb/map_print)

MapPrint allows for exporting many map sources and GeoJSON to a pdf file. Allowing to specify map element, text/image elements as well as printing a legend with the reference and a scale bar.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'map_print'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install map_print

## Usage

### Executable 

`map_print print --south-west="-35.026862,-58.425003" --north-east="-29.980172,-52.959305" --zoom="10" --output="output.png"`

Indicating southwest and northeast to determine the bounding box. Set the zoom at which the tiles should be requested.

In addition set the `output` path to which the resulting image will be written.

This is intended to be more of a testing method as it doesn't support all the options available and always returns a png. In the future we might provide more functionality depending on feature request.

### In ruby code

The mos common usage you'll be expecting is to create a new instance with the map configuration and then call `print` with the output path. MapPrint will take the map configuration, generate the map and write the output to the output path. In the example below `./map.png`.

```ruby
MapPrint::Core.new(map_configuration).print('./map.png')```

`map_configuration` is a hash with the following options:

```ruby
BASIC_MAP = {
    format: 'pdf', # pdf or png
    pdf_options: {
      page_size: 'A4', # A0-10, B0-10, C0-10
      page_layout: :portrait # :portrait, :landscape
    },
    map: {
      sw: { # required
        lat: -35.026862,
        lng: -58.425003
      },
      ne: { # required
        lat: -29.980172,
        lng: -52.959305
      },
      zoom: 9, # whatever is supported by the source, typically between 1-15
      position: { # x,y position on the PDF (as prawn determines it)
        x: 50,
        y: 50
      },
      size: { # Resize the map image, typically used to print the map on pdf
        width: 500,
        height: 800
      },
      layers: [{ # Whatever layers you want to include. Currently only OSM and Bing are supported
        type: 'osm', # (osm, bing) to understand variable substitution and stitching toghether the final image
        urls: ['http://a.tile.thunderforest.com/transport/${z}/${x}/${y}.png'], # currently only one is being used, in the future it will load balance
        level: 1, # used to order the layer appearance
        opacity: 1.0 # in case you want the layer to have some transparency
      }], # see geojson specification for feature/object support. See http://leafletjs.com/reference.html#path-options for formatting options, the following attributes under properties are supported: `stroke, color, weight, opacity, fill, fillColor, fillOpacity, fillRule, dashArray, lineCap, lineJoin`
      geojson: '{
        "type": "FeatureCollection",
        "features": [{
          "type":"Feature",
          "geometry":{"type":"Point", "coordinates":[-32.026862,-55.425003]},
          "properties":{"image": "./marker.png"}
        }, {
          "type": "Feature",
          "geometry": {"type": "LineString", "coordinates": [ [-32.026862,-55.425003], [-31.026862,-55.425003], [-31.026862,-54.425003], [-32.026862,-54.425003] ] },
          "properties": {"color": "#000000"}
        }, {
          "type": "Feature",
          "geometry": {"type": "Polygon", "coordinates": [ [-32.126862,-55.825003], [-31.426862,-55.225003], [-31.326862,-54.825003], [-32.146862,-54.835003] ] },
          "properties": {
            "stroke": true,
            "color": "#000000",
            "weight": 2,
            "opacity": 1,
            "fill": true,
            "fillColor": "#ffffff",
            "fillOpacity": 1,
            "fillRule": "evenodd",
            "dashArray": "5,2,3",
            "lineCap": "round",
            "lineJoin": "round"
          }
        }]
      }'
    },
    images: [ # not supported yet
      {
        path: './file.png',
        position: {x: 50, y: 50 },
        size: {width: 50, height: 50},
        options: {}
      }
    ],
    texts: [ # not supported yet
      {
        text: "some text",
        position: {x: 50, y: 50 },
        size: {width: 50, height: 50},
        options: {}
      }
    ],
    legend: { # not supported yet
      position: {x: 50, y: 50},
      size: {width: 50, height: 50},
      columns: 5,
      rows: 5,
      elements: [{
        image: './file.png',
        text: 'text'
      }]
    },
    scalebar: { # not supported yet
      unit: 'meters', # meters, km, miles, feet
      position: {x: 50, y: 50},
      size: {width: 50, height: 50}
    }
  }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afast/map_print.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).