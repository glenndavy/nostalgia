class Nostalgia::Slab
  attr_accessor :stats
  #STAT items:5:number 66
  #STAT items:5:age 566742
  #STAT items:5:evicted 0
  #STAT items:5:evicted_nonzero 0
  #STAT items:5:evicted_time 0
  #STAT items:5:outofmemory 0
  #STAT items:5:tailrepairs 0
  #STAT items:5:reclaimed 3
  #STAT 5:chunk_size 224
  #STAT 5:chunks_per_page 4681
  #STAT 5:total_pages 1
  #STAT 5:total_chunks 4681
  #STAT 5:used_chunks 66
  #STAT 5:free_chunks 14
  #STAT 5:free_chunks_end 4601
  #STAT 5:mem_requested 13209
  #STAT 5:get_hits 170616
  #STAT 5:cmd_set 182
  #STAT 5:delete_hits 0
  #STAT 5:incr_hits 0
  #STAT 5:decr_hits 0
  #STAT 5:cas_hits 0
  #STAT 5:cas_badval 0
  
  def initialize
    @stats = {}
  end

  def self.new_from_stats_hash(stats={})
    new_slab = self.new
    new_slab.merge_stats(stats)
    new_slab
  end

  def merge_stats(stats={})  
    stats.each do |key, stat|
      self.stats[key] = stat
      self.class.send( :define_method, key, eval("lambda {return stats[:" + key.to_s + "]}"))
    end 
  end

  def ratio_of_sets_to_hits
    cmd_set / get_hits  if get_hits > 0
  end

  def evictions_before_expiry
    evicted
  end

  def evictions_before_access
    evicted_nonzero
  end

  def items_storable_per_page
    ((1024 * 1024) / chunk_size).floor
  end

  def minimum_space_wasted_per_page
    (1024 * 1024) % chunk_size
  end

  def maximum_usable_space_per_page
    (1024 * 1024) - minimum_space_wasted_per_page
  end

  def current_maximum_possible_items_without_malloc
    items_storable_per_page * total_pages
  end

  def current_minimum_space_wasted
    total_pages * minimum_space_wasted_per_page
  end

  def memory_allocated
    #TODO change  so that variable page sizes can be used
    total_pages * 1_048_576
  end

  def usable_memory
    total_chunks * chunk_size
  end

  def memory_utilised
    used_chunks * chunk_size
  end

  def unused_memory
    memory_allocated - memory_utilised
  end

  def unusable_memory
    memory_allocated - usable_memory
  end

  def memory_wasted_across_items
    usable_memory - mem_requested
  end

  def memory_wasted_across_slab
    memory_allocated - mem_requested
  end

  def seconds_since_last_eviction
    evicted_time
  end

  def ratio_of_evictions_to_items_set
    evicted  / cmd_set if cmd_set > 0
  end

  def volume_of_evictions
    evicted * chunk_size
  end

  def percentage_of_evictions_never_accessed
    (evicted_nonzero / evicted) * 100.0 if evicted > 0
  end

  def ratio_of_reclaimed_items_to_evicted_items
    reclaimed / evicted if evicted > 0
  end

  def summary(display_units=:kb)
    display_factor = case display_units.to_sym
    when :bytes then 1.0
    when :kb   then 1024.0
    when :mb   then 1024.0*1024.0
    else 1
    end


    "Chunk size                                                                               : #{chunk_size} bytes \n" + \
    "Number of pages                                                                          : #{total_pages}\n" + \
    "Chunks per page                                                                          : #{chunks_per_page}\n" + \
    "Number of chunks used                                                                    : #{used_chunks} \n" + \
    "Maximum space usable per page                                                            : #{maximum_usable_space_per_page} \n" + \
    "Minium space wasted per page                                                             : #{minimum_space_wasted_per_page} \n" + \
    "Maximum possible items in slab (without  growing)                                        : #{current_maximum_possible_items_without_malloc / display_factor} #{display_units}\n" + \
    "Current minimum space wasted                                                             : #{current_minimum_space_wasted / display_factor} #{display_units} \n" +\
    "Memory Allocated (memory actually consuned)                                              : #{memory_allocated / display_factor} #{display_units}\n" + \
    "Usable memory                                                                            : #{usable_memory / display_factor} #{display_units}\n" + \
    "Requested memory                                                                         : #{mem_requested / display_factor} #{display_units}\n" + \
    "Used   memory (memory containng data )                                                   : #{memory_utilised / display_factor} #{display_units}\n" + \
    "Unused memory (allocated but not yet used)                                               : #{unused_memory / display_factor} #{display_units}\n" + \
    "Unusable memory (memory at end of slabs which cant ever be used)                         : #{unusable_memory / display_factor} #{display_units}\n" + \
    "Memory wasted across items (space due to difference between item size and chunk size)    : #{memory_wasted_across_items  / display_factor} #{display_units}\n" + \
    "Memory wasted across slab (whats asked for vs whats provided)                            : #{memory_wasted_across_slab   / display_factor} #{display_units}\n" + \
    "Seconds since last eviction                                                              : #{evicted_time}\n" + \
    "Age of oldest item in slab                                                               : #{age}\n" + \
    "sets:hits                                                                                : #{ratio_of_sets_to_hits}\n" + \
    "Ratio of evictions to items set                                                          : #{ratio_of_evictions_to_items_set}\n" + \
    "Evicted before expired                                                                   : #{evictions_before_expiry}\n" + \
    "Evicted never accessed                                                                   : #{evictions_before_access}\n" + \
    "Percentage of eviction never accessed                                                    : #{ percentage_of_evictions_never_accessed }\n" + \
    "Number of times chunk has been reused after expiry                                       : #{reclaimed}\n" + \
    "Reclaimed items compared to evicted items                                                : #{ratio_of_reclaimed_items_to_evicted_items}\n" + \
    "Volume of data evicted before use                                                        : #{volume_of_evictions  / display_factor} #{display_units}\n" + \
    "outofmemory                                                                              : #{outofmemory}\n"
  end
end
