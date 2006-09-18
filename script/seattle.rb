#!/usr/local/bin/ruby

ENV["RAILS_ENV"] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment'

if ARGV.first == "wipe" then
  Group.delete_all

  seattle = Group.new
  seattle.name = "Seattle Ruby Brigade!"
  seattle.city = "Seattle, WA"
  seattle.save
else
  seattle = Group.find_by_city "Seattle, WA"
  seattle.urls.clear 
  seattle.contacts.clear
  seattle.locations.clear
end

seattle.new_url "web", "http://www.zenspider.com/seattle.rb"
seattle.new_url "mail", "mailto:ruby@zenspider.com"
seattle.new_url "irc", "irc://irc.freenode.net/#seattle.rb"

ryan = seattle.new_contact "Ryan Davis", "ryand-ruby@zenspider.com"
eric = seattle.new_contact "Eric Hodel", "drbrain@segment7.net"

robot  = seattle.new_location "Robot Co-op", "1205 E Pike #2F, Seattle, WA 98102"
vivace = seattle.new_location "Vivace Cafe", "901 East Denny Way, Seattle, WA 98122"

require 'date'
class Time
  SEC_PER_DAY = 86400

  def to_s
    strftime "%Y-%m-%d"
  end

  def midnight
    self - (self.hour * 3600 - self.min * 60 - self.sec)
  end

  def next_week
    self + 7 * SEC_PER_DAY
  end
end

t = Time.now.midnight
last = t + 60 * Time::SEC_PER_DAY
t += Time::SEC_PER_DAY until t.wday == 2 # tuesday
dow = "tuesday"

until t > last do
  next_week = t.next_week

  if next_week.month != t.month then
    seattle.new_event "Monthly Meeting", "#{t} 19:00", vivace, 120
  else
    seattle.new_event "Hack Night. Everyone is welcome!", "#{t} 19:00", vivace, 120
  end
  
  t = next_week
end


