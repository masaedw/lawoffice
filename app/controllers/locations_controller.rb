class LocationsController < ApplicationController

  def list
    @list = Location.find(:all, :order => 'position')
  end

  def sort
    params['locations-table'].each_with_index do |id, position|
      Location.update(id, :position => position)
    end
    render :nothing => true
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
