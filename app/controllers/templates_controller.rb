class TemplatesController < ApplicationController
  def create
    @mt = Template.new(params[:template])
    @mt.save

    @mt = Template.find(:first, :order => 'id DESC')

    @list = Template.find(:all, :order => 'name')

    # FIXME: IE でselectが表示されない
    # 1, IE で edit mode にアクセスし、「テンプレートの編集」ボタンを押さずに(ウインドウを開かずに)
    # 他のクライアントでメモの作成を行い、更新処理を行わせると、テンプレートウインドウを表示したときに
    # select が表示されない。
    # メモの削除の場合は大丈夫。

    shoot_list
    render :update do |page|
      page << "new MemoTemplate(#{@mt.element_id.to_json}, #{@mt.name.to_json}, #{@mt.color.to_json}, #{@mt.content.to_json});"
      page.replace_html "template_select", '<option value="0">新規テンプレート</option>'+options_from_collection_for_select(@list, "id", "name")
      page << "TemplateWindow.edit_mode(#{@mt.element_id.to_json});"
    end
  end

  def update
    @mt = Template.find(params[:id])
    @mt.update_attributes(params[:template])

    @list = Template.find(:all, :order => 'name')

    shoot_list
    render :update do |page|
      page << "new MemoTemplate(#{@mt.element_id.to_json}, #{@mt.name.to_json}, #{@mt.color.to_json}, #{@mt.content.to_json});"
      page << "var t = $F('template_select');"
      page.replace_html "template_select", '<option value="0">新規テンプレート</option>'+options_from_collection_for_select(@list, "id", "name")
      page << "$('template_select').setValue(t);"
    end
  end

  def delete
    template = Template.find(params[:id])
    template.destroy

    js = render_to_string :update do |page|
      page << "TemplateWindow.destroy(#{template.element_id.to_json});"
    end
    shoot_both js

    render :nothing => true
  end

  private

  def shoot_list
    js = render_to_string :update do |page|
      page << "new MemoTemplate(#{@mt.element_id.to_json}, #{@mt.name.to_json}, #{@mt.color.to_json}, #{@mt.content.to_json});"
      page << "if (!edit_mode) {"
      page << "var t = $F('tmemo_template_select');"
      page.replace_html "memo_template_select", '<option value="0">----</option>'+options_from_collection_for_select(@list, "id", "name")
      page << "$('memo_template_select').setValue(t);"
      page << "} else {"
      page << "var t = $F('template_select');"
      page.replace_html "template_select", '<option value="0">新規テンプレート</option>'+options_from_collection_for_select(@list, "id", "name")
      page << "$('template_select').setValue(t);"
      page << "}"
    end
    shoot_both js
  end
end
