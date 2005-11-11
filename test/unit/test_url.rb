require File.dirname(__FILE__) + '/../test_helper'

class TestUrl < Test::Unit::TestCase
  fixtures :groups, :urls

  def setup
    @url = Url.find(101)
  end

  def test_fixtures
    assert_kind_of Url,  @url
  end
end
