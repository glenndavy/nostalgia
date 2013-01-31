require 'spec_helper'
require 'debugger'

describe 'Nostalgia::Memcached' do

  describe ' instance stats' do

    before  do
      # Monkey patch collect_stats to get stats from fixtures
      @memcached_instance =  Nostalgia::Memcached.new

      parser=Parser.new
      parser.load_from_files(Dir.getwd + '/spec/fixtures/stats')

      @memcached_instance.general_stats = parser.globals
      @memcached_instance.slabs    = parser.slabs
    end

    it 'should correctly calculate the ratio_of_sets_to_gets' do
      @memcached_instance.ratio_of_sets_to_gets.must_equal(230103402.0 / 914756157.0)
    end 

    it 'should have  correct ratio of hits_to_misses' do
      @memcached_instance.ratio_of_hits_to_misses.must_equal(626258184.0 /288497973.0)
    end

    it 'should correctly calculate the ratio of writes to reads' do
      @memcached_instance.ratio_of_bytes_written_to_bytes_read.must_equal(2121241633323.0 / 9881626616521.0)
    end

    it 'should correctly calculate the ratio of reclaimed items to evicted items' do
      @memcached_instance.ratio_of_reclaimed_items_to_evicted_items.must_equal(7708332.0 / 220424478.0)
    end

    it 'should correctly calculate the ratio of evicted_items_to_total_items' do
      @memcached_instance.ratio_of_evicted_items_to_total_items.must_equal( 220424478.0 / 230103335.0 )
    end
  end
  describe ' aggregate slab stats' do
    before do
      @memcached_instance =  Nostalgia::Memcached.new

      parser=Parser.new
      parser.load_from_files(Dir.getwd + '/spec/fixtures/stats', Dir.getwd + '/spec/fixtures/slabs',  Dir.getwd + '/spec/fixtures/items')

      @memcached_instance.general_stats = parser.globals
      @memcached_instance.slabs         = parser.slabs
    end

    it 'should have an array of slab items' do
      #@memcached_instance.slabs.class.must_equal Nostalgia::Slabs
      @memcached_instance.slabs.each{|key,slab| slab.class.must_equal Nostalgia::Slab}
    end
  end
end
