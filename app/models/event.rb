class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :group
  has_many :subjects, :exclusively_dependent => true

  def date
    self.start.strftime('%F %l:%M%p').sub(/\s+/, ' ').downcase[0..-2]
  end

  def new_subject description
    subject = Subject.new :description => description
    self.subjects << subject
    self.save
    subject
  end
end
