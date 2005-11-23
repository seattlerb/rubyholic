require File.dirname(__FILE__) + '/../test_helper'

class TestGroup < Test::Unit::TestCase
  fixtures :groups, :locations

  def setup
    @group = Group.find(101)
  end

  def test_fixtures
    assert_kind_of Group,  @group
  end

  def test_new_contact
    util_new @group, :contact, 'a name', 'an email', 'password'
  end

  def test_add_url
    util_new @group, :url, 'www', 'http://www.example.com/'
  end

  def test_add_location
    util_new @group, :location, "a location"
  end

  def test_add_event
    util_new @group, :event, "Monthly Meeting", "2005-11-29 19:00", @amazon_locotion
  end

end
