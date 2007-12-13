class BbsMemosController < MemosController
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
        page << "MemoDisplay.find('memo_display_#{i+1}').display('#{memo.element_id}', '#{date memo.created_at}', #{memo.content.to_json}, '#{memo.color}', #{memo.checked});"
      end
      links = paginating_links_each(@memos) do |n|
        link_to_function n, "BBSWindow.page(#{n})"
      end
      page.replace_html 'memo_paginate', links
    end
  end
end
