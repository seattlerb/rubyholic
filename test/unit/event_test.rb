require File.dirname(__FILE__) + '/../test_helper'

class TestEvent < Test::Unit::TestCase
  fixtures :groups, :locations, :events

  def setup
    @event = Event.find(101)
  end

  def test_fixtures
    assert_kind_of Event,  @event
  end

  def test_start_date
    assert_equal '2005-11-01 7:00p', @event.start_date
  end

  def test_start_date_nil
    @event.start = nil # some people are difficult
    assert_equal 'bad date', @event.start_date
  end

  def test_end_time
    assert_equal '10:00p', @event.end_time
  end

  def test_end_time_nil_start
    @event.start = nil # some people are difficult
    assert_equal 'for 180 minutes', @event.end_time
  end

  def test_end_time_nil_duration
    @event.duration = nil # some people are difficult
    assert_equal '', @event.end_time
  end

  def test_rfc2445_start_date
    assert_equal '20051101T190000', @event.rfc2445_start_date
  end

  def test_rfc2445_start_date_nil
    @event.start = nil # some people are difficult
    assert_equal '', @event.rfc2445_start_date
  end

  def test_rfc2445_end_date
    assert_equal '20051101T220000', @event.rfc2445_end_date
  end

  def test_rfc2445_end_date_nil_start
    @event.start = nil # some people are difficult
    assert_equal '', @event.rfc2445_end_date
  end

  def test_rfc2445_end_date_nil_duration
    @event.duration = nil # some people are difficult
    assert_equal '20051101T190000', @event.rfc2445_end_date
  end

  def test_add_subject
    util_new @event, :subject, 'a subject'
  end

end
