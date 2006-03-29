require File.dirname(__FILE__) + '/../test_helper'

class TestLocation < Test::Unit::TestCase
  fixtures :groups, :locations

  def setup
    @location = Location.find(101)
  end

  def test_fixtures
    assert_kind_of Location,  @location
  end

  def test_google_url
    assert_equal "http://maps.google.com/maps?q=1205+E+Pike+St,+%232F,+Seattle,+WA+98102&hl=en", @location.google_url
  end
end
