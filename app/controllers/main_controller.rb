class MainController < ApplicationController

  def home
    @schedules = Schedule.find(:all)
    @templates = Template.find(:all, :order => "name")
  end

  def edit
    @schedules = Schedule.find(:all)
    @templates = Template.find(:all, :order => "name")
  end
end
