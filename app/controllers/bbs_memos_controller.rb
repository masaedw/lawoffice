class BbsMemosController < MemosController
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
    memo = Memo.find(params[:id])
    memo.content = params[:content]
    memo.save

    render :nothing => true
  end

  def person_check_or_reset
    assoc = InterestedPerson.find(:first, :conditions => ["person_id = ? AND bbs_memo_id = ?", params[:person_id], params[:id]])
    assoc.checked = params[:flag] == "true"
    assoc.save

    notice_unread(assoc.person)

    render :nothing => true
  end

  private

  def memo_list
    opts = {:order => 'created_at DESC', :page => {:size => MemosController.view_num, :current => params[:page]}}
    unless params[:query].blank?
      add_condition(opts, ["match(content) against(?)", params[:query]])
    end
    if params[:unread] == "true"
      add_condition(opts, ["checked = ?", false])
    end
    if !params[:year].blank? && !params[:month].blank? && !params[:day].blank?
      begin
        add_condition(opts, ["DATE(created_at) = ?", Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)])
      rescue ArgumentError
      end
    end
    @memos = BbsMemo.find(:all, opts)
  end

  def render_list
    render :update do |page|
      page << "BBSWindow.clear_display();"
      @memos.each_with_index do |memo, i|
        obj = {
          :id => memo.element_id, :date => date(memo.created_at),
          :content => memo.content, :color => memo.color, :checked => memo.checked,
          :dests => memo.interested_people.map{|ip|
            {:name => ip.person.name, :id => ip.person.element_id, :checked => ip.checked}
          }
        }
        page << "MemoDisplay.find('memo_display_#{i+1}').display(#{obj.to_json});"
      end
      links = paginating_links_each(@memos) do |n|
        link_to_function n, "BBSWindow.page(#{n})"
      end
      page.replace_html 'memo_paginate', links
    end
  end

  def notice_unread person
    js = render_to_string :update do |page|
      page << "if (!edit_mode) {"
      page << "Person.update_bbs_unread('#{person.element_id}', #{person.bbs_unread});"
      page << "}"
    end
    shoot_both js
  end
end
