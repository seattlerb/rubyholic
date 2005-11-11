
class Group < ActiveRecord::Base
  has_many :contacts
  has_many :locations, :order => "name ASC"
  has_many :events, :order => "start ASC"
  has_many :urls

  def new_contact(name, email)
    c = Contact.new(:name => name, :email => email)
    self.contacts << c
    self.save
    c
  end

  # TODO: the rest of the creators
end
