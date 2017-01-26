module Nostalgia
  ALPHABET = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  class Simulations
    def self.simulate(maximum_item_size=1024*1024, scaling_factor=10, itterations=10)
      itterations.times do |i|
        min_size = 10
        max_offset = 10 
        size = min_size + rand(max_offset)
        begin
        while size < maximum_item_size  do
          key   = (0..rand(255)).map{  ALPHABET[rand(ALPHABET.size)]}.join
          value = (0..rand(size)).map{  ALPHABET[rand(ALPHABET.size)]}.join
          puts "itteration #{i} - setting #{key}, wth a #{value.size} lengthed value"
          Connection.set(key,value)
          min_size = size + max_offset
          max_offset = min_size / scaling_factor
          size = min_size + rand(max_offset)
          sleep 0.25
        end
        rescue => e
          puts e.message
          Nostalgia.connect
          retry
        end
      end
    end
  end
end
