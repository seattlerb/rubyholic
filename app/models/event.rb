class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :group
  has_many :subjects

  def date
    self.start.strftime('%F %l:%M%p').sub(/\s+/, ' ').downcase[0..-2]
  end
end
