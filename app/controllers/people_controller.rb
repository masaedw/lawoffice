class PeopleController < ApplicationController

  def list
    @list = Person.find(:all)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
