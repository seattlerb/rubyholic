class GroupsController < ApplicationController

#   verify(:exclude => [ :index, :list, :show, :login, ],
#          :session => :email,
#          :add_flash => { :note => "You must log in to edit"},
#          :redirect_to => :login)

  def index
    @group = Group.new
    @groups = Group.find :all, :order => "name"
    unless params[:bad] then
      @groups = @groups.select { |g| g.good? }
    else
      @groups = @groups.reject { |g| g.good? }
    end
  end

  def show
    @group = Group.find params[:id]
  end

  def edit
    @group = Group.find params[:id]
  end

  def update
    @group = Group.find params[:id]
    if @group.update_attributes(params[:group])
      flash[:notice] = 'Group was successfully updated.'
      redirect_to :action => 'edit', :id => @group
    else
      render :action => 'edit'
    end
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = 'Group was successfully created.'
      redirect_to :action => 'edit', :id => @group.id
    else
      render :action => 'index'
    end
  end

  def add_url
    @group = Group.find params[:id]

    @missing_url = !params.include?(:url)
    @missing_label = !params.include?(:label)

    if @group and not (@missing_label or @missing_url) then
      @group.new_url params[:label], params[:url]
      @group.reload
    end

    render :partial => 'urls'
  end

  def del_url
    Url.destroy params[:url_id]
    @group = Group.find params[:id]
    render :partial => 'urls'
  end

  def add_contact
    @group = Group.find params[:id]
    if @group then
      @group.new_contact params[:name], params[:email]
      @group.reload
    end
    render :partial => 'contacts'
  end

  def del_contact
    Contact.destroy params[:contact_id]
    @group = Group.find params[:id]
    render :partial => 'contacts'
  end

  def add_location
    @group = Group.find params[:id]
    @group.new_location params[:name], params[:address]
    @group.reload
    render :partial => 'locations_and_events'
  end

  def del_location
    Location.destroy params[:location_id]
    @group = Group.find params[:id]
    render :partial => 'locations_and_events'
  end

  def add_event
    @group = Group.find params[:id]

    hours, minutes = params[:duration].split(':', 2)
    duration = hours.to_i * 60 + minutes.to_i

    @group.new_event params[:summary], params[:start], params[:location_id],
                     duration
    @group.reload
    render :partial => 'locations_and_events'
  end

  def del_event
    Event.destroy params[:event_id]
    @group = Group.find params[:id]
    render :partial => 'locations_and_events'
  end

  def add_subject
    # REFACTOR: make a method on event: new_subject(desc)
    Subject.create :description => params[:description], :event_id => params[:event_id]
    @group = Group.find params[:id]
    render :partial => 'locations_and_events'
  end

  def del_subject
    Subject.destroy params[:subject_id]
    @group = Group.find params[:id]
    render :partial => 'locations_and_events'
  end
end
