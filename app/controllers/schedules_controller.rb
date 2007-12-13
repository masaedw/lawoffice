class SchedulesController < ApplicationController
  def update
    schedule = Schedule.find(params[:id])
    schedule.body = params[:body]
    schedule.save

    js = render_to_string :update do |page|
      page << "Schedule.set(#{schedule.id}, #{schedule.body.to_json});"
    end
    shoot_both js

    render :nothing => true
  end
end
