require 'test_helper'

describe MapPrint::Tile do
  let(:lat_lng) { MapPrint::LatLng.new(-35.026862, -58.425003) }
  let(:lat_lng2) { MapPrint::LatLng.new(-29.980172, -52.959305) }
  let(:x) { lat_lng2.get_slippy_map_tile_number(3)[:x] }
  let(:y) { lat_lng2.get_slippy_map_tile_number(3)[:y] }
  let(:tile) { MapPrint::Tile.new(x, y, 3, 'http://test.com/${z}/${y}/${x}') }

  describe '.meters_per_pixel' do
    (0..18).each do |zoom|
      it "returns METERS_PER_PIXELS for #{zoom} zoom level" do
        MapPrint::Tile.meters_per_pixel(zoom).must_equal MapPrint::Tile::METERS_PER_PIXELS[zoom]
      end
    end
  end

  describe '#coords' do
    it 'returns x, y & z' do
      tile.coords.must_equal({x: 2, y: 4, z: 3})
    end
  end

  describe '#download' do
    it 'downloads the tile' do
      proc {
        tile.download
      }.must_raise RuntimeError
    end
  end

  describe '#get_pixel_difference' do
    it 'returns pixel difference from tile center to lat_lng' do
      tile.get_pixel_difference(lat_lng).must_equal({x: 0.41410936341549665, y: 0.5633788803017731})
    end
  end

  describe '#tile_number_to_lat_lng' do
    it 'returns the lat_lng for the current tile' do
      tile.tile_number_to_lat_lng.must_equal({lat: 0.0, lng: -90.0})
    end
  end

  describe '#file_path' do
    it 'raises an error asking subclasses to implement it' do
      proc {
        tile.file_path.must_equal ''
      }.must_raise RuntimeError
    end
  end

  describe '#provider_name' do
    it 'raises an error asking subclasses to implement it' do
      proc {
        tile.provider_name
      }.must_raise RuntimeError
    end
  end
  describe '#provider_name' do
    it 'raises an error asking subclasses to implement it' do
      proc {
        tile.cache_name
      }.must_raise RuntimeError
    end
  end

  describe '#provider_name' do
    it 'raises an error asking subclasses to implement it' do
      proc {
        tile.tile_url
      }.must_raise RuntimeError
    end
  end
end
