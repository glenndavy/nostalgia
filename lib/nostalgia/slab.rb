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

  def ratio_of_sets_to_gets
    cmd_set / cmd_get if cmd_get > 0
  end

  def ratio_of_sets_to_hits
    cmd_set / get_hits  if get_hits > 0
  end

  def ratio_of_hits_to_misses
    get_hits / get_misses if get_misses > 0
  end

  def evictions_before_expiry
    evicted
  end

  def evictions_before_access
    evicted_nonzero
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
    memory_utilised - mem_requested
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
    evicted_nonzero / evicted if evicted > 0
  end

  def ratio_of_reclaimed_items_to_evicted_items
    reclaimed / evicted if evicted > 0
  end
end