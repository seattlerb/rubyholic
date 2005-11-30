require 'uri'

class Location < ActiveRecord::Base
  belongs_to :group
  has_many :events, :exclusively_dependent => true

  def google_url
    "http://maps.google.com/maps?q=#{URI.encode self.address}&hl=en".gsub(/%20/, '+')
  end
end
