#!/usr/local/bin/ruby

ENV["RAILS_ENV"] = 'development'
require File.dirname(__FILE__) + '/../config/environment'

Group.delete_all

seattle = Group.new
seattle.name = "Seattle Ruby Brigade!"
seattle.city = "Seattle, WA"
seattle.save

seattle.new_url "web", "http://www.zenspider.com/seattle.rb"
seattle.new_url "mail", "mailto:ruby@zenspider.com"
seattle.new_url "irc", "irc://irc.freenode.net/#seattle.rb"

ryan = seattle.new_contact "Ryan Davis", "ryand-ruby@zenspider.com"
eric = seattle.new_contact "Eric Hodel", "drbrain@segment7.net"

amazon = seattle.new_location "Amazon US1"
robot  = seattle.new_location "Robot Co-op"

monthly = seattle.new_event "Monthly Meeting", "2005-11-29 19:00", amazon
weekly  = seattle.new_event "Weekly Meeting", "2005-11-15 19:00", robot

monthly.new_subject "Evan Webb on Sydney"
monthly.new_subject "Eric Hodel on TDD for Rails"


