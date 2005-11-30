#!/usr/local/bin/ruby

ENV["RAILS_ENV"] ||= 'development'
require File.dirname(__FILE__) + '/../config/environment'

if ARGV.empty? then
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

amazon = seattle.new_location "Amazon US1", "605 5th Ave, Seattle, WA 98104"
robot  = seattle.new_location "Robot Co-op", "1205 E Pike #2F, Seattle, WA 98102"
redline  = seattle.new_location "Red Line Cafe", "1525 E Olive Way, Seattle, WA 98122"

monthly = seattle.new_event "Monthly Meeting", "2005-11-29 19:00", amazon
monthly.new_subject "Joe Heitzeberg on Asterisk and R/AGI"

monthly = seattle.new_event "Monthly Meeting", "2005-12-27 19:00", redline
monthly.new_subject "Eric Hodel on Hard Core TDD for Rails"
monthly.new_subject "Evan Webb on Sydney"

seattle.new_event "Weekly Hacking", "2005-11-01 19:00", robot
seattle.new_event "Weekly Hacking", "2005-11-08 19:00", robot
seattle.new_event "Weekly Hacking", "2005-11-15 19:00", robot
seattle.new_event "Weekly Hacking", "2005-11-22 19:00", robot
seattle.new_event "Weekly Hacking", "2005-12-06 19:00", redline
seattle.new_event "Weekly Hacking", "2005-12-13 19:00", redline
seattle.new_event "Weekly Hacking", "2005-12-20 19:00", redline
