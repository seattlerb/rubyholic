class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :group
  has_many :subjects, :exclusively_dependent => true

  def start_date
    d = self.start
    if d then
      d.strftime('%F %l:%M%p').sub(/\s+/, ' ').downcase[0..-2]
    else
      "bad date"
    end
  end

  def end_time
    return '' if duration.nil?
    d = self.start
    if d then
      (d + 60 * duration).strftime('%l:%M%p').sub(/\s+/, ' ').downcase[0..-2]
    else
      "for #{duration} minutes"
    end
  end

  def rfc2445_start_date
    return '' if start.nil?
    start.strftime '%Y%m%dT%H%M%S'
  end

  def rfc2445_end_date
    return '' if start.nil?
    (start + 60 * duration.to_i).strftime '%Y%m%dT%H%M%S'
  end

  def new_subject description
    subject = Subject.new :description => description
    self.subjects << subject
    self.save
    subject
  end
end
