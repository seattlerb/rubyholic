class GroupsController < ApplicationController

  def index
    @groups = Group.find :all
  end

  def show
    @group = Group.find params[:id]
  end

  def edit
    @group = Group.find params[:id]
  end

  def add_url
    @group = Group.find params[:id]
    if @group then
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

  def add_location
    @group = Group.find params[:id]
    Location.create :name => params[:name], :group_id => @group.id
    @group.reload
    render :partial => 'locations'
  end

  def del_location
    Location.destroy params[:location_id]
    @group = Group.find params[:id]
    render :partial => 'locations'
  end

  def add_event
    @group = Group.find params[:id]
    Event.create :summary => params[:summary], :group_id => @group.id, :location_id => params[:location_id], :start => params[:start]
    @group.reload
    render :partial => 'events'
  end

  def del_event
    Event.destroy params[:event_id]
    @group = Group.find params[:id]
    render :partial => 'events'
  end

  def add_subject
    Subject.create :description => params[:description], :event_id => params[:event_id]
    @group = Group.find params[:id]
    render :partial => 'events'
  end

  def del_subject
    Subject.destroy params[:subject_id]
    @group = Group.find params[:id]
    render :partial => 'events'
  end
end
