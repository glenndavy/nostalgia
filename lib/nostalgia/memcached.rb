module Nostalgia
  class Memcached
    attr_accessor :general_stats, :slabs
    def initialize
      @parser = Parser.new
      #@slabs  = Nostalgia::Slabs.new
    end

    def collect_stats
      ["stats", "stats slabs", "stats items"].each do |message| 
        Connection.message(message)  do |line|
          @parser.parse_line line
        end 
      end
      @general_stats = @parser.globals
      @slabs    = @parser.slabs
    end

    def ratio_of_sets_to_gets
      @general_stats[:cmd_set] / @general_stats[:cmd_get]         if @general_stats[:cmd_get] > 0
    end

    def ratio_of_hits_to_misses
      @general_stats[:get_hits] / @general_stats[:get_misses]     if @general_stats[:get_misses] > 0
    end

    def ratio_of_bytes_written_to_bytes_read
      @general_stats[:bytes_written] / @general_stats[:bytes_read] if @general_stats[:bytes_read] > 0
    end

    def ratio_of_current_items_to_total_items
      @general_stats[:curr_items] / @general_stats[:total_items]   if @general_stats[:total_items] > 0
    end

    def ratio_of_reclaimed_items_to_evicted_items
      @general_stats[:reclaimed] / @general_stats[:evictions]      if @general_stats[:evictions] > 0
    end

    def ratio_of_evicted_items_to_total_items
      @general_stats[:evictions] / @general_stats[:total_items]    if @general_stats[:total_items] > 0
    end
    
    
    #todo make a container object for slabs and put this functionality into it
    def sort_by(m)
      @slabs.sort{|(k,slab),(k1,slab1)| slab.send(m) <=> slab1.send(m)}
    end

    def max(m)
      @slabs.max{|(k,slab),(k1,slab1)| slab.send(m) <=> slab1.send(m)}
    end

    def min(m)
      @slabs.min{|(k,slab),(k1,slab1)| slab.send(m) <=> slab1.send(m)}
    end

    def total(m)
      @slabs.inject(0){|sum,(k,slab)| sum + slab.send(m)}
    end
  end
end
