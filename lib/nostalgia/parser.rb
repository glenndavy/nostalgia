class Parser

  attr_accessor :slabs, :globals

  TYPES = { :rusage_user   => :float,
            :rusage_system => :float,
            :version       => :string,
            :cas_enabled   => :boolean,
            :inter         => :boolean, 
            :detail_enabled => :boolean,
            :auth_enabled_sasl => :boolean,
            :maxconns_fast     => :boolean,
            :slab_reassign     => :boolean,
            :slab_automove     => :boolean,
            :slab_moved        => :boolean,
            :slab_moved        => :boolean,
          }

  def initialize
    @slabs   = {}
    @globals = {}
  end

  def load_from_files
    %w(stats items slabs).each do |filename|
      IO.readlines(filename).each do |line|
        puts "about to parse #{line}"
        parse_line(line)
      end
    end
  end

  def parse_line(line)
    slab_line_re    = /^STAT (\d+):([a-z_]*) (\d+)/
    item_line_re    = /^STAT items:(\d+):([a-z_]*) (\d+)/
    global_line_re  = /^STAT ([a-z_]+)\ (.*)\n$/
    end_re          = /^END$/

    if global_line_re.match(line)
      puts "global setting matched"
      key   = $1
      value = $2
      value = cast(value, (TYPES[key.to_sym]||:integer)) 
      @globals[key]=value
    end

    if slab_line_re.match(line)
      puts "slab matched: #{line}"
      key = $1.to_i
      result = {$2 => $3.to_i}
      unless @slabs.has_key?(key)
        @slabs[key] = {}
      end
      @slabs[key].merge!(result)
    end

    if item_line_re.match(line)
      puts "item matched: #{line}"
      key = $1.to_i
      result = {$2 => $3.to_i}
      unless @slabs.has_key?(key)
        @slabs[key] = {}
      end
      @slabs[key].merge!(result)
    end
  end

  def cast(v,t="integer")
    v = case t
        when :integer
          v.to_i
        when :boolean
          !!v
        when :string
          v.to_s
        when :float
          v.to_f
        end
  end
end
