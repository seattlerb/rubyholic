class Contact < ActiveRecord::Base
  attr_accessor :passwd

  belongs_to :group

  SALT = "Not Eric's Salt"

  def self.hash_password(raw)
    SHA1.sha1("#{SALT}:#{raw}").to_s
  end

  def self.authenticate email, passwd
    find_by_email_and_password(email, hash_password(passwd))
  end
  
  def before_save
    self.password = Contact.hash_password(self.passwd) unless self.passwd.nil? or self.passwd.empty?
    self.passwd = nil
  end
end
