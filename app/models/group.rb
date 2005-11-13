
class Group < ActiveRecord::Base
  has_many :contacts
  has_many :locations, :order => "name ASC"
  has_many :events, :order => "start ASC"
  has_many :urls

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

  def new_location(location)
    _new_thing Location, :name => location
  end

  def new_event(what, wwhen, where)
    _new_thing Event, :summary => what, :start => wwhen, :location_id => where.id
  end
end
