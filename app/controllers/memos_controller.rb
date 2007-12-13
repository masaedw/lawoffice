class MemosController < ApplicationController

  def self.view_num
    10
  end

  def view
    memo_list
    render_list
  end

  def create
    memo = Memo.new
    memo.content = params[:content]
    memo.person_id = params[:id]
    memo.color = "#ffffff"
    if params[:template].to_i != 0
      memo.template = Template.find(params[:template])
      memo.color = memo.template.color;
    end
    memo.save

    memo_list
    notice_unread(@person)
    render_list
  end

  def update
    memo = Memo.find(params[:id])
    memo.content = params[:content]
    memo.save

    render :nothing => true
  end

  def check
    check_or_reset true
  end

  def reset
    check_or_reset false
  end

  def print
    @memo = Memo.find(params[:id], :include => "person")
    render :layout => false
  end

  private

  def memo_list
    @person = Person.find(params[:id])
    opts = {:order => 'ctime DESC', :page => {:size => MemosController.view_num, :current => params[:page]}}
    unless params[:query].blank?
      add_condition(opts, ["match(content) against(?)", params[:query]])
    end
    if params[:unread] == "true"
      add_condition(opts, ["checked = ?", false])
    end
    if !params[:year].blank? && !params[:month].blank? && !params[:day].blank?
      begin
        add_condition(opts, ["DATE(ctime) = ?", Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)])
      rescue ArgumentError
      end
    end
    @memos = @person.memos.find(:all, opts)
  end

  def notice_unread person
    js = render_to_string :update do |page|
      page << "if (!edit_mode) {"
      page << "Person.update_unread('#{person.element_id}', #{person.unread});"
      page << "}"
    end
    shoot_both js
  end

  def check_or_reset flag
    memo = Memo.find(params[:id])
    memo.checked = flag
    memo.save

    notice_unread(memo.person)

    render :nothing => true
  end

  def render_list
    render :update do |page|
      page << "MemoWindow.clear_display();"
      @memos.each_with_index do |memo, i|
        page << "MemoDisplay.find('memo_display_#{i+1}').display('#{memo.element_id}', '#{date memo.ctime}', #{memo.content.to_json}, '#{memo.color}', #{memo.checked});"
      end
      links = paginating_links_each(@memos) do |n|
        link_to_function n, "MemoWindow.page(#{n})"
      end
      page.replace_html 'memo_paginate', links
    end
  end

  def add_condition param, conds
    if param.include?(:conditions)
      param[:conditions][0] += " AND #{conds[0]}"
      param[:conditions].concat conds[1..-1]
    else
      param[:conditions] = conds
    end
    param
  end
end
