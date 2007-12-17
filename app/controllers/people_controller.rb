require 'json'

class PeopleController < ApplicationController
  before_filter :find_all, :only => [:list, :edit]
  before_filter :find_id, :only => [:update_message, :update_position, :update_location]
  after_filter  :expire_destination_table, :only => [:create, :destroy, :update_position]

  def list
    @list
  end

  def new
  end

  def create
    person = Person.create(:name => "新規", :phone => "", :message => "", :posx => 100, :posy => 100)

    js = render_to_string :update do |page|
      page << "if (!edit_mode) {"
      page.insert_html :bottom, 'people', render(:partial => 'person', :object => person)
      page << "} else {"
      page.insert_html :bottom, 'people', render(:partial => 'edit', :object => person)
      page << "}"
    end
    shoot_both js

    render :update do |page|
      page.insert_html :bottom, 'people', render(:partial => 'edit', :object => person)
    end
  end

  def edit
    @list
    # update_remote のときに Draggable#destroy を呼ぶべきか調べる。
    # 必要なら呼ぶようにする。
  end

  def update_message
    @person.message = params[:message]
    if @person.save
      js = render_to_string :update do |page|
        page << "Person.update_text('#{@person.element_id}', 'message', #{j @person.message});"
      end
      shoot_both(js)

      render :update do |page|
        page << "j$('##{@person.element_id} span.message').html(#{j @person.message});"
      end
    else
      render :nothing => true
    end
  end

  def update_position
    @person.posx = params[:left].to_i
    @person.posy = params[:top ].to_i
    if @person.save
      js = render_to_string :update do |page|
        page.visual_effect :move, @person.element_id, :x => @person.left, :y => @person.top, :mode => '"absolute"'
      end
      shoot_both(js)
    end

    render :nothing => true
  end

  def update_location
    location = Location.find(params[:location])
    @person.location = location
    @person.message = ""
    locations = Location.find(:all, :order => 'position')
    if @person.save
      js = render_to_string :update do |page|
        page << "if (!edit_mode) {"
        page.replace_html 'locations-table', render(:partial => 'locations/item', :collection => locations)
        page << "}"
        page << "Person.find('#{@person.element_id}').update_location('#{location.element_id}');"
        page << "Person.update_text('#{@person.element_id}', 'message', '');"
      end
      shoot_both(js)

      render :update do |page|
        page.replace_html 'locations-table', render(:partial => 'locations/item', :collection => locations)
        page << "Person.find('#{@person.element_id}').update_location('#{location.element_id}');"
        page << "Person.update_text('#{@person.element_id}', 'message', '');"
      end
    else
      render :nothing => true
    end
  end

  def update_text
    @person = Person.find(params[:id])
    need_expire = @person.name != params[:name]
    @person.name = params[:name]
    @person.phone = params[:phone]

    if @person.save
      js = render_to_string :update do |page|
        page << "Person.update_text('#{@person.element_id}', 'name', #{j @person.name});"
        page << "Person.update_text('#{@person.element_id}', 'phone', #{j @person.phone});"
      end
      shoot_both js
      expire_destination_table if need_expire
    end

    render :nothing => true
  end

  def destroy
    @person = Person.find(params[:id], :include => "location")
    @person.destroy
    js = render_to_string :update do |page|
      page.remove @person.element_id
      if @person.location
        page << "if (!edit_mode) {"
        page.replace @person.location.element_id, render(:partial => 'locations/item', :object => @person.location)
        page << "}"
      end
    end
    shoot_both js

    render :update do |page|
      page.remove @person.element_id
    end
  end

  private

  def find_all
    @list = Person.find(:all, :include => :location)
  end

  def find_id
    @person = Person.find(params[:id])
  end

  def expire_destination_table
    bms = BbsMemo.find(:all, :select => "id")
    bms.each do |bm|
      expire_page(:controller => "bbs_memos", :action => "dest_table", :id => bm.id)
    end
    expire_page(:controller => "bbs_memos", :action => "dest_table")
  end
end
