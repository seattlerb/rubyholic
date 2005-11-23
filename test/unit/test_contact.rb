require File.dirname(__FILE__) + '/../test_helper'

class TestContact < Test::Unit::TestCase
  fixtures :groups, :contacts

  def setup
    @contact = Contact.find(101)
  end

  def test_fixtures
    assert_kind_of Contact, @contact
  end

  # echo -n "Not Eric's Salt:password" | openssl sha1 -hex
  # echo -n "Not Eric's Salt:new_password" | openssl sha1 -hex

  PASSWORD = '9d8e9d477af73d7d051bba97fbb62c05aff5aa08'
  NEW_PASSWORD = 'fa5a692c1ab410bb67d257163bc37ee7a5f1eafc'

  def test_class_authenticate
    contact = Contact.authenticate @ryan.email, 'password'
    assert_equal @ryan, contact
  end

  def test_class_authenticate_bad_password
    contact = Contact.authenticate @ryan.email, 'bad password'
    deny_equal @ryan, contact
  end

  def test_before_create
    contact = Contact.create :name => 'new_user', :email => 'new_user@example.com', :passwd => 'password', :group_id => @seattle.id
    deny contact.new_record?
    assert_equal PASSWORD, contact.password
  end

  def test_before_update_empty_password
    @ryan.passwd = ''
    assert @ryan.save
    assert_equal PASSWORD, @ryan.password
  end

  def test_before_update_new_password
    @ryan.passwd = 'new password'
    assert @ryan.save
    assert_equal NEW_PASSWORD, @ryan.password
  end
end
