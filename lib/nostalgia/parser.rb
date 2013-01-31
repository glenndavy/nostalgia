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

  def load_from_files(*files)
    files.each do |filename|
      IO.readlines(filename).each do |line|
        parse_line(line)
      end
    end
  end

  def parse_line(line)
    slab_line_re    = /^STAT (\d+):([a-z_]*) (\d+)/
    item_line_re    = /^STAT items:(\d+):([a-z_]*) (\d+)/
    global_line_re  = /^STAT ([a-z_]+)\ (.*)\n$/
    end_re          = /^END$/


    if slab_line_re.match(line)
      slab_key = $1.to_i
      key      = $2.to_sym
      value    = $3
      result = { key => cast(value,(TYPES[key]||:float))}
      unless @slabs.has_key?(slab_key)
        @slabs[slab_key] = Nostalgia::Slab.new 
      end
      @slabs[slab_key].merge_stats(result)
    end

    if item_line_re.match(line)
      slab_key = $1.to_i
      key      = $2.to_sym
      value    = $3
      result = {key => cast(value,(TYPES[key]||:float))}
      unless @slabs.has_key?(slab_key)
        @slabs[slab_key] = Nostalgia::Slab.new 
      end
      @slabs[slab_key].merge_stats(result)
    end

    if global_line_re.match(line)
      key   = $1.to_sym
      value = $2
      value = cast(value, (TYPES[key]||:float)) 
      @globals[key]=value
    end
  end

  def cast(v,t=:float)
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
