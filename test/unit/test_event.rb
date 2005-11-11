require File.dirname(__FILE__) + '/../test_helper'

class TestEvent < Test::Unit::TestCase
  fixtures :groups, :locations, :events

  def setup
    @event = Event.find(101)
  end

  def test_fixtures
    assert_kind_of Event,  @event
  end

  def test_date
    assert_equal '2005-11-01 7:00p', @event.date
  end

  def test_add_subject
    util_new @event, :subject, 'a subject'
  end

end
