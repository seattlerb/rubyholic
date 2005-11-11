require File.dirname(__FILE__) + '/../test_helper'

class TestContact < Test::Unit::TestCase
  fixtures :groups, :contacts

  def setup
    @contact = Contact.find(101)
  end

  def test_fixtures
    assert_kind_of Contact,  @contact
  end
end
