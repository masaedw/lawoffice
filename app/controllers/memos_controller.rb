class MemosController < ApplicationController

  def view
    memo_list
    render :partial => 'view_item', :collection => @memos
  end

  def new
  end

  def create
  end

  def update
  end

  def check
  end

  def reset
  end

  def print
  end

  def search
  end

  private

  def memo_list
    @person = Person.find(params[:id])
    @memos = @person.memos.find(:all, :order => 'ctime DESC', :page => {:size => 10, :current => params[:page]})
  end
end
