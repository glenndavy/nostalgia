require "nostalgia/version"
require "nostalgia/configuration"
require "nostalgia/connection"
require "nostalgia/slabs"
require "nostalgia/parser"
require "nostalgia/memcached"
require "nostalgia/slab"

module Nostalgia
  def self.configure(connection_hash={})
    Configuration.host=connection_hash[:host] || "localhost"
    Configuration.port=connection_hash[:port] || "11211"
  end

  def self.connect
    Connection.connect
  end
end
