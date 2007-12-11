class MainController < ApplicationController

  def home
    @templates = Template.find(:all, :order => "name")
  end

  def edit
    @templates = Template.find(:all, :order => "name")
  end
end
