class PeopleController < ApplicationController
  before_filter :find_all, :only => [:list, :edit]
  before_filter :find_id, :only => [:update_message, :update_position, :update_location]

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

    render :nothing => true
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
        page << "Person.update_text('#{@person.element_id}', 'message', '#{h @person.message}');"
      end
      shoot_both(js)
    end

    render :nothing => true
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
    end
    render :nothing => true
  end

  def destroy
  end

  private

  def find_all
    @list = Person.find(:all, :include => :location)
  end

  def find_id
    @person = Person.find(params[:id])
  end
end
