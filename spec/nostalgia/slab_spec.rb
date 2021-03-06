require 'spec_helper'

describe Nostalgia::Slab do
  describe 'Creating a new slab from stats' do
    it 'should create a new popluated slab' do
      slab = Nostalgia::Slab.new_from_stats_hash(:abc => "ABC", :def => "DEF")
      slab.stats[:abc].must_equal "ABC"
      slab.abc.must_equal "ABC"
      slab.stats[:def].must_equal "DEF"
      slab.def.must_equal "DEF"
      other_slab = Nostalgia::Slab.new_from_stats_hash(:abc => "-abc-", :def => "-def-") 
      other_slab.stats[:abc].must_equal "-abc-"
      other_slab.abc.must_equal "-abc-"
      other_slab.def.must_equal "-def-"
      other_slab.stats[:def].must_equal "-def-"
      other_slab.stats[:abc].must_equal "-abc-"
      slab.abc.must_equal "ABC"
      slab.def.must_equal "DEF"
    end

  end

  describe 'Slab stats' do
    before :each do
      @stats = {
        :number => 66,
        :age => 566742,
        :evicted => 0,
        :evicted_nonzero => 0,
        :evicted_time => 0,
        :outofmemory => 0,
        :tailrepairs => 0,
        :reclaimed => 3,
        :chunk_size => 224,
        :chunks_per_page => 4681,
        :total_pages => 1,
        :total_chunks => 4681,
        :used_chunks => 66,
        :free_chunks => 14,
        :free_chunks_end => 4601,
        :mem_requested => 13209,
        :get_hits => 170616,
        :cmd_set => 182,
        :delete_hits => 0,
        :incr_hits => 0,
        :decr_hits => 0,
        :cas_hits => 0,
        :cas_badval => 0
      }
      @slab = Nostalgia::Slab.new_from_stats_hash(@stats)
    end

    it 'should correctly calculate raw stats' do
      @stats.each_key do |k|
        @slab.send(k).must_equal(@stats[k])
      end
    end

    it 'should correctly calculate calculated set to hit ratio' do
      @slab.ratio_of_sets_to_hits.must_equal( 182 / 170616 )
    end

    it 'should correctly calculate evictions_before_expiry' do
      @slab.evictions_before_expiry.must_equal 0
    end

    it 'should correctly calculate evictions_before_explicit_expiry' do
      @slab.evictions_before_explicit_expiry.must_equal 0
    end

    it 'should correctly calculate memory usable' do
      @slab.memory_utilised.must_equal( 14784 )
    end

    it 'should correctly calculate memory utilised' do
      @slab.memory_utilised.must_equal( 14_784 )
    end

    it 'should correctly calculate memory allocated' do
      @slab.memory_allocated.must_equal( 1_048_576 )
    end

    it 'should correctly calculate memory unused' do
      @slab.unused_memory.must_equal( 1_033_792 )
    end

    it 'should correctly calculate unusable memory' do
      @slab.unusable_memory.must_equal( 32 )
    end

    it 'should correctly calculate wasted_memory across items' do
      @slab.memory_wasted_across_items.must_equal( 1035335 )
    end

    it 'should correctly calculate wasted_memory across slab' do
      @slab.memory_wasted_across_slab.must_equal( 1_035_367 )
    end
   
    it 'should correctly calculate ratio of sets to evictions' do
      @slab.ratio_of_evictions_to_items_set.must_equal 0
    end


    it 'should correctly calculate volume_of_evictions' do
      @slab.volume_of_evictions.must_equal 0
    end

    it 'should correctly calculate percentage_of_evictions_with_explicit_expiry' do
      @slab.percentage_of_evictions_with_explicit_expiry.must_equal nil
    end

    it 'should correctly calculate ratio of reclaimed items to evicted items' do
      @slab.ratio_of_reclaimed_items_to_evicted_items.must_equal nil
    end
    describe "slab summary" do
      it "should run without breaking" do
        @slab.summary.class.must_equal String
      end
    end
  end
end
