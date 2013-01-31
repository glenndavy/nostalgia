# Nostalgia

A gem to use when looking back fondly on your memcached stats.


## Usage

````
cd nostalgia
bundle exec irb -r 'nostalgia'
Nostalgia.configure
Nostalgia.connect
mc=Nostalgia::Memcached.new
mc.collect_stats

# Then poke around. A quick summary available with:
mc.summary
````
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
