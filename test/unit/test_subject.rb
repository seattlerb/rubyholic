require File.dirname(__FILE__) + '/../test_helper'

class TestSubject < Test::Unit::TestCase
  fixtures :groups, :locations, :events, :subjects

  def setup
    @subject = Subject.find(101)
  end

  def test_fixtures
    assert_kind_of Subject,  @subject
  end
end
