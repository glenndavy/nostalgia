require 'socket'

module Nostalgia
  class Connection

    def self.connection
      @connection
    end

    def self.connect
      @connection = Socket.tcp(Nostalgia::Configuration.host,Nostalgia::Configuration.port)
    end

    def self.message(msg, &blk)
      @connection.puts(msg)
      while line=@connection.gets
        yield line 
        break if line.match /(END|ERROR)/
      end
    end
  end
end
