
class Group < ActiveRecord::Base

  RUBYHOLIC_VERSION = "1.0" unless defined? RUBYHOLIC_VERSION

  has_many :contacts, :exclusively_dependent => true
  has_many :locations, :order => "name ASC", :exclusively_dependent => true
  has_many :events, :order => "start ASC", :exclusively_dependent => true
  has_many :urls, :exclusively_dependent => true

  def _new_thing(model, params)
    singular = model.name.downcase
    plural = Inflector.pluralize(singular)

    thing = model.new params
    self.send(plural) << thing
    thing.save
    thing
  end

  def new_contact(name, email)
    _new_thing Contact, :name => name, :email => email
  end

  def new_url(label, url)
    _new_thing Url, :label => label, :url => url
  end

  def new_location(location, address)
    _new_thing Location, :name => location, :address => address
  end

  def new_event(what, wwhen, where)
    where = where.id if Location === where
    _new_thing Event, :summary => what, :start => wwhen, :location_id => where
  end

  def good?
    return ! (contacts.empty? or locations.empty?)
  end

end
