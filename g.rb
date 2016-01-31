#!/usr/bin/env ruby
# g.rb - Command line for Google Now
# Usage: ruby g.rb "20 + 30 * 1/2"
# Usage: ruby g.rb "what is the capital of washington"
# Usage: ruby g.rb "128371 bytes per second in MBps"
#
# (c) 2009 Mauricio Gomes <mauricio@edge14.com>
# Updated by @joech4n to work with other Google Now results

%w(mechanize addressable/uri).each do |lib|
  begin
    require lib
  rescue LoadError => e
    puts "#{e.message}: Please run `#{`which gem`.chomp} install #{lib.split('/')[0]}`"
    exit
  end
end

uri = Addressable::URI.parse("http://www.google.com/search")
uri.query_values = {q: ARGV*' '}
uri = uri.normalize.to_s
doc = Mechanize.new.get(uri)

if doc.at_css('h2.r')
  # for Google Calculator
  puts doc.search("//h2[@class='r']").inner_text
else
  # for everything else
  # TODO: pretty-print some of the other queries (like "will it rain on Monday?")
  # TODO: find commands that do not work
  # FIXME: sports queries do not work ("how are the Broncos doing?")
  puts doc.search("//div[@id='ires']/ol/*[1]").inner_text
end
