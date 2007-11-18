class LocationsController < ApplicationController
  before_filter :find_all, :only => [:list, :edit]

  def list
    @list
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
    @list
  end

  def update
    @location = Location.find(params[:id])
    @location.name = params[:name]
    @location.color = params[:color]
    @location.listup = !params[:listup].blank?
    if @location.save
      js = render_to_string :update do |page|
        page.replace @location.element_id, render(:partial => 'item', :object => @location)
        @location.people.each do |person|
          page << "Person.find('#{person.element_id}').update_location('#{@location.element_id}')"
        end
      end
      Meteor.shoot('lawoffice-view', js)

      js = render_to_string :update do |page|
        page.replace @location.element_id, render(:partial => 'edit', :object => @location)
        @location.people.each do |person|
          page << "Person.find('#{person.element_id}').update_location('#{@location.element_id}')"
        end
      end
      Meteor.shoot('lawoffice-edit', js)
    end

    render :nothing => true
  end

  def destroy
  end

  private

  def find_all
    @list = Location.find(:all, :order => 'position')
  end
end
