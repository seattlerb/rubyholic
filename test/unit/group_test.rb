require File.dirname(__FILE__) + '/../test_helper'

class TestGroup < Test::Unit::TestCase
  fixtures :groups, :locations, :contacts

  def setup
    @group = Group.find(101)
  end

  def test_name_or_default
    @group.name = ""
    assert_equal "Name Missing! Please Fix", @group.name_or_default
  end

  def test_name_or_default_nil
    @group.name = nil
    assert_equal "Name Missing! Please Fix", @group.name_or_default
  end

  def test_fixtures
    assert_kind_of Group,  @group
  end

  def test_new_contact
    util_new @group, :contact, 'a name', 'an email'
  end

  def test_add_url
    util_new @group, :url, 'www', 'http://www.example.com/'
  end

  def test_add_location
    util_new @group, :location, "a location", "an address"
  end

  def test_add_event
    amazon_locotion = locations(:amazon_locotion)
    util_new @group, :event, "Monthly Meeting", "2005-11-29 19:00", amazon_locotion, 120
  end

  def test_good_eh
    assert @group.good?
  end

  def test_good_eh_no_location
    bad_group2 = groups(:bad_group2)
    assert ! bad_group2.good?
  end

  def test_good_eh_no_contact
    bad_group1 = groups(:bad_group1)
    assert ! bad_group1.good?
  end

end
