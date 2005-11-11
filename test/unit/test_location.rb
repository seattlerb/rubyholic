require File.dirname(__FILE__) + '/../test_helper'

class TestLocation < Test::Unit::TestCase
  fixtures :groups, :locations

  def setup
    @location = Location.find(101)
  end

  def test_fixtures
    assert_kind_of Location,  @location
  end
end
