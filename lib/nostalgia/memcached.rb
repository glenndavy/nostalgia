module Nostalgia
  class Memcached
    attr_accessor :general_stats, :slabs
    def initialize
      @parser = Parser.new
      @general_stats = {}
      @slabs = {}
      #@slabs  = Nostalgia::Slabs.new
    end

    def collect_stats
      ["stats", "stats slabs", "stats items"].each do |message| 
        Connection.message(message)  do |line|
          @parser.parse_line line
        end 
      end

      methods_from_stats(@parser.globals)
      @slabs    = @parser.slabs
    end

    def methods_from_stats(stats={})
      stats.each do |key, stat|
        @general_stats[key] = stat
        self.class.send( :define_method, key, eval("lambda {return @general_stats[:" + key.to_s + "]}"))
      end 
    end

    def ratio_of_sets_to_gets
      @general_stats[:cmd_set].to_f / @general_stats[:cmd_get].to_f         if @general_stats[:cmd_get].to_f > 0
    end

    def ratio_of_hits_to_misses
      @general_stats[:get_hits].to_f / @general_stats[:get_misses].to_f     if @general_stats[:get_misses].to_f > 0
    end

    def ratio_of_bytes_written_to_bytes_read
      @general_stats[:bytes_written].to_f / @general_stats[:bytes_read].to_f if @general_stats[:bytes_read].to_f > 0
    end

    def ratio_of_current_items_to_total_items
      @general_stats[:curr_items].to_f / @general_stats[:total_items].to_f   if @general_stats[:total_items].to_f > 0
    end

    def ratio_of_reclaimed_items_to_evicted_items
      @general_stats[:reclaimed].to_f / @general_stats[:evictions].to_f      if @general_stats[:evictions].to_f > 0
    end

    def ratio_of_evicted_items_to_total_items
      @general_stats[:evictions].to_f / @general_stats[:total_items].to_f    if @general_stats[:total_items].to_f > 0
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

    def minimum_wasted_memory
      total(:current_minimum_space_wasted)
    end

    def summary(display_units=:kb)
      display_factor = case display_units.to_sym
      when :bytes then 1.0
      when :kb   then 1024.0
      when :mb   then 1024.0*1024.0
      when :gb   then 1024.0*1024.0*1024.0
      else 1
      end
     
      "Uptime                                                   : #{uptime} seconds ( #{ChronicDuration.output(uptime, :weeks => true)}\n "     + \
      "Version                                                  : #{version}\n "    + \
      "Current Items                                            : #{curr_items}\n " + \
      "Total Items                                              : #{total_items}\n" + \
      "Bytes used to store items                                : #{bytes}\n"       + \
      "Get commmands                                            : #{cmd_get}\n"     + \
      "Set commmands                                            : #{cmd_set}\n"     + \
      "Ratio of sets to gets                                    : #{ratio_of_sets_to_gets}\n" + \
      "Get hits                                                 : #{get_hits}\n"    + \
      "Get misses                                               : #{get_misses}\n"  + \
      "Ratio of hits to misses                                  : #{ratio_of_hits_to_misses}\n" + \
      "Items reclaimed                                          : #{reclaimed}\n"   + \
      "bytes read                                               : #{bytes_read / display_factor} #{display_units}\n"   + \
      "bytes written                                            : #{bytes_written / display_factor} #{display_units}\n"   + \
      "Ratio of bytes written to bytes read                     : #{ratio_of_bytes_written_to_bytes_read}\n" + \
      "Maximum size of server                                   : #{limit_maxbytes / display_factor} #{display_units}\n"   + \
      #"Expired unfetched                                        : #{expired_unfetched}\n" + \
      #"Evicted unfetched                                        : #{evicted_unfetched}\n" + \
      "Ratio of reclaimed items to evicted items                : #{ratio_of_reclaimed_items_to_evicted_items}\n" + \
      "Percentage items that get evicted                        : #{ratio_of_evicted_items_to_total_items * 100.0}\n"
      "Connection Structures                                    : #{connection_structures}\n"
    end
  end
end
