#! /usr/bin/env ruby
require 'nostalgia'

Nostalgia.configure
Nostalgia.connect
mc=Nostalgia::Memcached.new
mc.collect_stats
outfile = File.open("/tmp/outfile","w")
outfile << mc.summary
mc.slabs.each{|k,slab| outfile << "Slab: #{k.to_s} ***\n"; outfile << slab.summary}
outfile.close

