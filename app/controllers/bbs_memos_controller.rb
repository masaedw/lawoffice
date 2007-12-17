require 'take_split'

class BbsMemosController < MemosController
  caches_page :dest_table

  def create
    memo = BbsMemo.new
    memo.content = params[:content]
    memo.color = "#ffffff"
    if params[:template].to_i != 0
      memo.template = Template.find(params[:template])
      memo.color = memo.template.color;
    end
    memo.save

    if !params[:dests].blank?
      ids = params[:dests].split(",").map{|i| i.to_i}
      people = Person.find(ids)
      people.each do |person|
        person.bbs_memos.push(memo)
      end
      notice_unread(people)
    end

    memo_list
    render_list(people)
  end

  def update
    memo = BbsMemo.find(params[:id])
    memo.content = params[:content]
    memo.save

    render :nothing => true
  end

  def print
    @memo = BbsMemo.find(params[:id], :include => "interested_people")
    render :layout => false
  end

  def update
    memo = BbsMemo.find(params[:id])
    memo.content = params[:content]
    memo.save

    if !params[:dests].blank?
      ids = params[:dests].split(",").map{|i| i.to_i}
      people = Person.find(:all)

      on, off = people.partition{|person| ids.include?(person.id)}

      changes = []

      on.each do |person|
        unless person.is_destination_of(memo)
          person.bbs_memos.push(memo)
          changes.push(person)
        end
      end

      off.each do |person|
        if person.is_destination_of(memo)
          person.bbs_memos.delete(memo)
          changes.push(person)
        end
      end

      notice_unread(changes)
      render(:partial => "notice_unread", :object => changes)
    else
      render :nothing => true
    end
  end

  def person_check_or_reset
    assoc = InterestedPerson.find(:first, :conditions => ["person_id = ? AND bbs_memo_id = ?", params[:person_id], params[:id]])
    assoc.checked = params[:flag] == "true"
    assoc.save

    notice_unread([assoc.person])

    render :nothing => true
  end

  def check_or_reset
    memo = BbsMemo.find(params[:id])
    memo.checked = params[:flag] == "true"
    memo.save

    render :nothing => true
  end

  def dest_table
    @memo = params[:id].blank? ? nil : BbsMemo.find(params[:id])
    @people = Person.find(:all)

    render :layout => false
  end

  def dest_list
    memo = BbsMemo.find(params[:id])
    render(:partial => "dest_table", :object => checked_group(memo.interested_people))
  end

  private

  def memo_list
    opts = {:order => 'created_at DESC', :page => {:size => MemosController.view_num, :current => params[:page]}}
    unless params[:query].blank?
      add_condition(opts, ["match(content) against(?)", params[:query]])
    end
    if params[:unread] == "true"
      add_condition(opts, ["checked <> ?", true])
    end
    if !params[:year].blank? && !params[:month].blank? && !params[:day].blank?
      begin
        add_condition(opts, ["DATE(created_at) = ?", Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)])
      rescue ArgumentError
      end
    end
    @memos = BbsMemo.find(:all, opts)
  end

  def render_list people = nil
    render :update do |page|
      page << "BBSWindow.clear_display();"
      @memos.each_with_index do |memo, i|
        obj = {
          :id => memo.element_id, :date => date(memo.created_at),
          :content => memo.content, :color => memo.color, :checked => memo.checked,
          :dest_list => render(:partial => "dest_table", :object => checked_group(memo.interested_people))
        }
        page << "MemoDisplay.find('memo_display_#{i+1}').display(#{obj.to_json});"
      end
      links = paginating_links_each(@memos) do |n|
        link_to_function n, "BBSWindow.page(#{n})"
      end
      page.replace_html 'memo_paginate', links
      if people
        page << render(:partial => "notice_unread", :object => people)
      end
    end
  end

  def notice_unread people
    shoot_both render_to_string(:partial => "notice_unread", :object => people)
  end

  include ApplicationHelper # for #checked_group
end
