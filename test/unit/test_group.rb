require File.dirname(__FILE__) + '/../test_helper'

class TestGroup < Test::Unit::TestCase
  fixtures :groups

  def setup
    @group = Group.find(101)
  end

  def test_fixtures
    assert_kind_of Group,  @group
  end

  def test_new_contact
    contacts = @group.contacts[0..-1]
    c = @group.new_contact 'a name', 'an email'
    new_contacts = @group.contacts - contacts
    assert_equal [c], new_contacts
  end
end
