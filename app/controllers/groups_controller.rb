class GroupsController < ApplicationController

  def index
    @group = Group.new
    @groups = Group.find :all
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
      Url.create(:url => params[:url], :label => params[:label], :group_id => @group.id)
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
    Location.create :name => params[:name], :group_id => @group.id
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
    Event.create :summary => params[:summary], :group_id => @group.id, :location_id => params[:location_id], :start => params[:start]
    @group.reload
    render :partial => 'locations_and_events'
  end

  def del_event
    Event.destroy params[:event_id]
    @group = Group.find params[:id]
    render :partial => 'locations_and_events'
  end

  def add_subject
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
