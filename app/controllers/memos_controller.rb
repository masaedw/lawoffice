class MemosController < ApplicationController

  def view
    memo_list
    render :partial => 'view_item', :collection => @memos
  end

  def new
  end

  def create
    memo = Memo.new
    memo.content = params[:content]
    memo.person_id = params[:id]
    memo.color = "#ffffff"
    if params[:template].to_i != 0
      memo.template = Template.find(params[:template])
    end
    memo.save

    memo_list

    js = render_to_string :update do |page|
      page << "if (!edit_mode) {"
      page << "Person.update_unread('#{@person.element_id}', #{@person.unread});"
      page << "}"
    end
    shoot_both js

    render :update do |page|
      page.replace_html "memo_window_display", render(:partial => 'view_item', :collection => @memos)
    end
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
