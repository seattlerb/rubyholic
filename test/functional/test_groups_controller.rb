require File.dirname(__FILE__) + '/../test_helper'

class TestGroupsController < FunctionalTestCase

  fixtures :groups, :contacts, :urls, :locations, :events, :subjects

  def test_index
    get :index
    assert_success

    assert_links_to "/groups/show/101"
    assert_links_to "mailto:ryand-rubyholic@zenspider.com"

    assert_tag :tag => 'div', :attributes => { :class => 'blurb' }
    assert_tag :tag => 'div', :attributes => { :class => 'list' }
    assert_tag :tag => 'div', :attributes => { :class => 'todo' }

    x = "/groups/create"
    assert_tag :tag => 'form', :attributes => { :action => x }
    assert_field x, :text, 'group', 'name'
    assert_field x, :text, 'group', 'city'
    assert_submit(x, "Create")
  end

  def test_show
    get :show, :id => @seattle.id
    assert_success

    assert_tag :tag => "h1", :content => "Seattle Ruby Brigade!"
    assert_tag :tag => "h2", :content => "Seattle, WA"

    assert_tag :tag => 'div', :attributes => { :id => 'urls' }
    assert_links_to @seattle_web_url.url,  @seattle_web_url.url
    assert_links_to @seattle_irc_url.url,  @seattle_irc_url.url
    assert_links_to @seattle_mail_url.url, @seattle_mail_url.url

    assert_tag :tag => "h3", :content => "Locations"

    assert_tag :tag => 'div', :attributes => { :id => 'locations' }

    # FIX: this is fucking horrible, who thinks this way?!?!
    assert_tag :tag => 'ul', :child => { :tag => 'li', :content => "Amazon US1" }
    assert_tag :tag => 'li', :content => "Robot Co-op", :after => { :tag => 'li', :content => "Amazon US1" }

    assert_tag :tag => "h3", :content => "Schedule"

    assert_tag :tag => 'div', :attributes => { :id => 'events' }

    calendar = {
      '2005-11-01 7:00p' => 'Robot Co-op: Weekly Meeting blah blah',
      '2005-11-29 7:00p' => 'Amazon US1: Monthly Meeting blah blah',
    }

    subjects = {
      '2005-11-29 7:00p' => [
        'Evan Webb on Sydney',
        'Eric Hodel on TDD for Rails',
      ]
    }

    assert_calendar calendar, subjects
  end

  def test_create
    name = "new group"
    city = "new city"

    orig_groups = Group.find(:all)
    get :create, :group => { :name => name, :city => city }

    new_groups = Group.find(:all) - orig_groups
    assert_equal 1, new_groups.size
    new_group = new_groups.first

    assert_redirect :action => "edit", :id => new_group.id
    assert_equal name, new_group.name
    assert_equal city, new_group.city
  end

  def test_update
    name = "new group"
    city = "new city"

    orig_groups = Group.find(:all)
    get :update, :id => @seattle.id, :group => { :name => name, :city => city }

    new_groups = Group.find(:all) - orig_groups
    assert_equal 0, new_groups.size

    group = Group.find @seattle.id

    assert_redirect :action => "edit", :id => group.id
    assert_equal name, group.name
    assert_equal city, group.city
  end

  def test_add_url
    url = "http://www.example.com/blah/#{Time.now.to_i}"
    orig_urls = @seattle.urls[0..-1]

    post :add_url, :id => @seattle.id, :url => url
    assert_success

    @seattle.reload
    new_urls = @seattle.urls - orig_urls

    assert 1, new_urls.size
    new_url = new_urls.first
    assert_not_nil new_url
    assert_kind_of Url, new_url
    assert_equal url, new_url.url
  end

  def test_del_url
    util_del @seattle, Url
  end

  def test_add_location
    location = "Ballet"
    orig_locations = @seattle.locations[0..-1]

    post :add_location, :id => @seattle.id, :name => location
    assert_success

    @seattle.reload
    new_locations = @seattle.locations - orig_locations

    assert 1, new_locations.size
    new_location = new_locations.first
    assert_not_nil new_location
    assert_kind_of Location, new_location
    assert_equal location, new_location.name
  end

  def test_del_location
    util_del @seattle, Location
  end

  def test_add_event
    summary = "Seattle.rb Lunch"
    start = '2005-12-01 12:00'
    loc = @robotcoop_location.id

    orig_events = @seattle.events[0..-1]

    post :add_event, :id => @seattle.id, :summary => summary, :location_id => loc, :start => start
    assert_success

    @seattle.reload
    new_events = @seattle.events - orig_events

    assert 1, new_events.size
    new_event = new_events.first
    assert_not_nil new_event
    assert_kind_of Event, new_event
    assert_equal summary, new_event.summary
    assert_equal @robotcoop_location, new_event.location
    assert_equal "#{start}p", new_event.date
  end

  def test_add_subject
    description = "Matz comes to party"

    orig_subjects = @monthly_event.subjects[0..-1]

    post :add_subject, :id => @seattle.id, :event_id => @monthly_event.id, :description => description
    assert_success

    @monthly_event.reload
    new_subjects = @monthly_event.subjects - orig_subjects

    assert 1, new_subjects.size
    new_subject = new_subjects.first
    assert_not_nil new_subject
    assert_kind_of Subject, new_subject
    assert_equal description, new_subject.description
  end

  def test_del_event
    util_del @seattle, Event # , :events, :del_event
  end

  def test_del_subject
    util_del @monthly_event, Subject # :subjects, :del_subject
  end

  def test_edit
    get :edit, :id => @seattle.id
    assert_success

    # flat data
    x = "/groups/update/#{@seattle.id}"
    assert_tag :tag => 'form', :attributes => { :action => x }
    assert_field x, :text, 'group', 'name'
    assert_field x, :text, 'group', 'city'
    assert_submit(x, "Update")

    # urls
    assert_tag :tag => "h2", :content => "URLs"

    assert_ajax_form('urls', '/groups/add_url',
                     { :type => 'text', :name => 'label', :value => /^$/ },
                     { :type => 'text', :name => 'url', :value => /^$/ },
                     { :type => 'image',  :src => '/images/add.png' })

    assert_section('urls', 
                   { :tag => 'td', :content => @seattle_web_url.url },
                   { :tag => 'td', :content => @seattle_mail_url.url },
                   { :tag => 'td', :content => @seattle_irc_url.url })

    assert_ajax_form('urls', '/groups/del_url',
                     { :type => 'hidden', :name => 'url_id', :value => @seattle_web_url.id },
                     { :type => 'image',  :src => '/images/delete.png' })
    
    # contacts
    assert_tag :tag => "h2", :content => "Contacts"

    assert_ajax_form('contacts', '/groups/add_contact',
                     { :type => 'text', :name => 'name', :value => /^$/ },
                     { :type => 'text', :name => 'email', :value => /^$/ },
                     { :type => 'image',  :src => '/images/add.png' })

    assert_section('contacts', 
                   { :tag => 'td', :content => @ryan_contact.email },
                   { :tag => 'td', :content => @eric_contact.email })

    assert_ajax_form('contacts', '/groups/del_contact',
                     { :type => 'hidden', :name => 'contact_id', :value => @eric_contact.id },
                     { :type => 'image',  :src => '/images/delete.png' })

    # locations
    assert_tag :tag => "h2", :content => "Locations"

    assert_ajax_form('locations', '/groups/add_location',
                     { :type => 'text', :name => 'name', :value => /^$/ },
                     { :type => 'image',  :src => '/images/add.png' })

    assert_section('locations',
                   { :tag => 'td', :content => @amazon_locotion.name },
                   { :tag => 'td', :content => @robotcoop_location.name })

    assert_ajax_form('locations', '/groups/del_location',
                     { :type => 'hidden', :name => 'location_id', :value => @robotcoop_location.id },
                     { :type => 'image',  :src => '/images/delete.png' })

    # events
    assert_tag :tag => "h2", :content => "Events"

    assert_ajax_form('events', '/groups/add_event',
                     { :type => 'text', :name => 'start', :value => /^YYYY-MM-DD hh:mm$/ },
                     { :type => 'text', :name => 'summary', :value => /^$/ },
                     { :type => 'image',  :src => '/images/add.png' }) do |url|
      assert_tag_in_form url, :tag => 'select', :attributes => { :name => 'location_id' }
    end

    assert_ajax_form('events', '/groups/del_event',
                     { :type => 'hidden', :name => 'event_id', :value => @monthly_event.id },
                     { :type => 'image',  :src => '/images/delete.png' })

    assert_section('events',
                   { :tag => 'td', :content => @amazon_locotion.name },
                   { :tag => 'td', :content => @robotcoop_location.name },
                   { :tag => 'td', :content => @evan_subject.description },
                   { :tag => 'td', :content => @eric_subject.description })

    assert_ajax_form('events', '/groups/add_subject',
                     { :type => 'hidden', :name => 'event_id', :value => @monthly_event.id },
                     { :type => 'text', :name => 'description', :value => /^$/ },
                     { :type => 'image',  :src => '/images/add.png' })

    assert_ajax_form('events', '/groups/del_subject',
                     { :type => 'hidden', :name => 'event_id', :value => @monthly_event.id },
                     { :type => 'hidden', :name => 'subject_id', :value => @evan_subject.id },
                     { :type => 'image',  :src => '/images/delete.png' })
  end

  def assert_section(name, *tests)
    tests.each do |attribs|
      assert_tag :tag => 'div', :attributes => { :id => name }, :descendant => attribs
    end
  end

  def assert_calendar(cal, sub)
    cal.each do |date, text|
      if sub.has_key? date then
        assert_tag(:tag => "li",
                   :content => "#{date}: #{text}",
                   :child => { :tag => "ul" })
        sub[date].each do |description|
          assert_tag :tag => "li", :content => description
        end
      else
        assert_tag :tag => "li", :content => "#{date}: #{text}"
      end
    end

    assert_match /#{cal.keys.sort.join('.+')}/m, @response.body
  end

  def assert_ajax_form(div, url, *tests)
    assert_tag :tag => 'form',             :attributes => { :action => url, :onsubmit => /'#{div}', '#{url}'/ }
    assert_tag_in_form url, :tag => 'input', :attributes => { :type => 'hidden', :name => 'id', :value => @seattle.id }

    tests.each do |params|
      assert_tag_in_form url, :tag => 'input', :attributes => params
    end

    yield(url) if block_given?
  end

  def util_del target, model, params={}
    singular = model.name.downcase
    plural = Inflector.pluralize(singular)

    primary_key = "#{singular}_id".intern
    msg = plural.intern
    action = "del_#{singular}"

    orig = target.send(msg)[0..-1]

    item_to_delete = orig.last

    params = params.merge(:id => target.id, primary_key => item_to_delete.id)

    post action, params
    assert_success

    target.reload

    items = orig - target.send(msg)

    assert 1, items.size
    assert_equal item_to_delete, items.first
  end

end
