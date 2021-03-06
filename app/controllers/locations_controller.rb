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
    people = Person.find(:all)

    js = render_to_string :update do |page|
      select0 = options_from_collection_for_select(locations, "id", "name")
      page << "if (!edit_mode) {"
      page.replace_html 'locations-table', render(:partial => 'item', :collection => locations)
      people.each do |person|
        if (person.location)
          page.replace_html person.element_id+"_select", options_from_collection_for_select(locations, "id", "name", person.location.id)
        else
          page.replace_html person.element_id+"_select", %Q{<option id="#{h person.element_id}_null_location"></option>}+select0
        end
      end
      page << "} else {"
      page.replace_html 'locations', render(:partial => 'edit', :collection => locations)
      page.sortable 'locations', :tag => 'div', :url => {:controller => 'locations', :action => 'sort'}
      page << "}"
    end
    shoot_both js

    render :nothing => true
  end

  def create
    max = Location.maximum('position')
    location = Location.create(:name => "新規", :listup => false, :color => "#eceef0", :position => max+1)
    people = Person.find(:all)

    js = render_to_string :update do |page|
      page << "if (!edit_mode) {"
      page.insert_html :bottom, 'locations-table', render(:partial => 'item', :object => location)
      people.each do |person|
        page << "var i = $F('#{person.element_id}_select');"
        page.insert_html :bottom, person.element_id+"_select", %Q{<option value="#{h location.id}">#{h location.name}</option>}
        page << "$('#{person.element_id}_select').setValue(i);"
      end
      page << "} else {"
      page.insert_html :bottom, 'locations', render(:partial => 'edit', :object => location)
      page.sortable 'locations', :tag => 'div', :url => {:controller => 'locations', :action => 'sort'}
      page << "}"
    end
    shoot_both js

    render :update do |page|
      page.insert_html :bottom, 'locations', render(:partial => 'edit', :object => location)
      page.sortable 'locations', :tag => 'div', :url => {:controller => 'locations', :action => 'sort'}
    end
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
        update_params = {"name" => h(@location.name), "color" => @location.color, "list" => user_list(@location)}

        page << "if (!edit_mode) {"
        page << "Location.update('#{@location.element_id}', #{update_params.to_json});"
        page << "$A(j$(\"option[@value=#{@location.id}]\")).each(function(i){$(i).update(#{j @location.name});});"
        page << "} else {"
        page.replace @location.element_id, render(:partial => 'edit', :object => @location)
        page << "}"
        @location.people.each do |person|
          page << "Person.find('#{person.element_id}').update_location('#{@location.element_id}');"
        end
      end
      shoot_both js

      render :update do |page|
        page << "$('#{@location.element_id}').style.backgroundColor = '#{@location.color}'"
        @location.people.each do |person|
          page << "Person.find('#{person.element_id}').update_location('#{@location.element_id}');"
        end
      end
    else
      render :nothing => true
    end
  end

  def destroy
    @location = Location.find(params[:id], :include => "people")
    @location.destroy
    js = render_to_string :update do |page|
      page.remove @location.element_id
      page << "j$(\"option[@value=#{@location.id}]\").remove();"
      @location.people.each do |person|
        page << "Person.find('#{person.element_id}').update_location(null);"
      end
    end
    shoot_both js

    render :update do |page|
      page.remove @location.element_id
      @location.people.each do |person|
        page << "Person.find('#{person.element_id}').update_location(null);"
      end
    end
  end

  private

  def find_all
    @list = Location.find(:all, :order => 'position')
  end
end
