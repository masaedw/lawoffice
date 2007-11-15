class PeopleController < ApplicationController

  def list
    @list = Person.find(:all)
  end

  def new
  end

  def create
  end

  def edit
    @list = Person.find(:all)
    # update_remote のときに Draggable#destroy を呼ぶべきか調べる。
    # 必要なら呼ぶようにする。
  end

  def update
    person = Person.find(params[:id])
    person.posx = params[:left].to_i
    person.posy = params[:top ].to_i
    if person.save
      js = <<-EOJ
        $('#{person.element_id}').style.left = #{person.left};
        $('#{person.element_id}').style.top = #{person.top};
      EOJ
      Meteor.shoot(person.monitoring_id(:view), js)
      Meteor.shoot(person.monitoring_id(:edit), js)
    end

    render :nothing => true
  end

  def destroy
  end
end
