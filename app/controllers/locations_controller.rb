class LocationsController < ApplicationController

  def list
    @list = Location.find(:all, :order => 'position')
  end

  def sort
    params['locations-table'].each_with_index do |id, position|
      Location.update(id, :position => position)
    end
    
    @list = Location.find(:all, :order => 'position')

    js = render_to_string :update do |page|
      page.replace_html 'locations-table', render(:partial => 'item', :collection => @list)
      page.sortable 'locations-table', :tag => 'tr', :url => {:controller => 'locations', :action => 'sort'}
    end
    
    Meteor.shoot('lawoffice', js)

    render :nothing => true
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
