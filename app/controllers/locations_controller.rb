class LocationsController < ApplicationController

  def list
    @list = Location.find(:all, :order => 'position')
  end

  def sort
    params['locations'].each_with_index do |id, position|
      Location.update(id, :position => position)
    end

    locations = Location.find(:all, :order => 'position')
    js = render_to_string :update do |page|
      page.replace_html 'locations-table', render(:partial => 'item', :collection => locations)
    end
    Meteor.shoot('lawoffice-view', js)

    js = render_to_string :update do |page|
      page.replace_html 'locations', render(:partial => 'edit', :collection => locations)
      page.sortable 'locations', :tag => 'div', :url => {:controller => 'locations', :action => 'sort'}
    end
    Meteor.shoot('lawoffice-edit', js)

    render :nothing => true
  end

  def new
  end

  def create
  end

  def edit
    @list = Location.find(:all, :order => 'position')
  end

  def update
  end

  def destroy
  end
end
