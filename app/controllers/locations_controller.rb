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
      page << "console.log(edit_mode);"
      page << "if (!edit_mode) {"
      page.replace_html 'locations-table', render(:partial => 'item', :collection => locations)
      page << "} else {"
      page.replace_html 'locations', render(:partial => 'edit', :collection => locations)
      page.sortable 'locations', :tag => 'div', :url => {:controller => 'locations', :action => 'sort'}
      page << "}"
    end
    shoot_both js

    render :nothing => true
  end

  def new
  end

  def create
    max = Location.maximum('position')
    Location.create(:name => "新規", :listup => false, :color => "#eceef0", :position => max+1)
    render :nothing => true
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
        page << "if (!edit_mode) {"
        page.replace @location.element_id, render(:partial => 'item', :object => @location)
        page << "} else {"
        page.replace @location.element_id, render(:partial => 'edit', :object => @location)
        page << "}"
        @location.people.each do |person|
          page << "Person.find('#{person.element_id}').update_location('#{@location.element_id}')"
        end
      end
      shoot_both js
    end

    render :nothing => true
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    js = render_to_string :update do |page|
      page.remove @location.element_id
    end
    shoot_both js

    render :nothing => true
  end

  private

  def find_all
    @list = Location.find(:all, :order => 'position')
  end
end
