class MainController < ApplicationController

  def home
    @schedules = Schedule.find(:all)
    @templates = Template.find(:all, :order => "name")
    @bbs_unread = BbsMemo.num_of_need_check
  end

  def edit
    @schedules = Schedule.find(:all)
    @templates = Template.find(:all, :order => "name")
  end
end
