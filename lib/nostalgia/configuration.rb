module Nostalgia
  class Configuration
    class << self
      attr_accessor :connection_url
      attr_accessor :host
      attr_accessor :port
    end
  end
end
