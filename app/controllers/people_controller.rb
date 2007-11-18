class PeopleController < ApplicationController
  before_filter :find_all, :only => [:list, :edit]
  before_filter :find_id, :only => [:update_message, :update_position]

  def list
    @list
  end

  def new
  end

  def create
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
      Meteor.shoot('lawoffice-view', js)
      Meteor.shoot('lawoffice-edit', js)
    end

    render :nothing => true
  end

  def update_position
    @person.posx = params[:left].to_i
    @person.posy = params[:top ].to_i
    if @person.save
      js = render_to_string :update do |page|
        page << <<-EOJ
          $("#{@person.element_id}").style.top = "#{@person.top}px";
          $("#{@person.element_id}").style.left = "#{@person.left}px";
        EOJ
      end
      Meteor.shoot('lawoffice-view', js)
      Meteor.shoot('lawoffice-edit', js)
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
