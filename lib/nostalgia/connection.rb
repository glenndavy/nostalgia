require 'socket'

module Nostalgia
  class Connection

    def self.connection
      self
    end
    
    def socket
      @socket
    end

    def self.connect
      @socket = Socket.tcp(Nostalgia::Configuration.host,Nostalgia::Configuration.port)
      self
    rescue SocketError
      ::Configuration
      @socket = Socket.tcp(Nostalgia::Configuration.host,Nostalgia::Configuration.port)
    end

    def self.message(msg)
      @socket.puts(msg)
      while line=@socket.gets
        yield line if block_given?
        break if line.match /(END|ERROR|STORED)/
      end 
    end

    def self.set(k, v, expire_time=0)
      message("set #{k} 0 #{expire_time} #{v.to_str.size}\r\n#{v.to_str}\r\n")
    end

    def self.get(k)
      result=[]
      message("get #{k}\r\n"){|line| result << line}
      result
    end
  end
  
end
