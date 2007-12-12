class TemplatesController < ApplicationController
  def create
    template = Template.new(params[:template])
    template.save

    template = Template.find(:first, :order => 'id DESC')

    @templates = Template.find(:all, :order => 'name')

    # FIXME: IE でselectが表示されない
    # 1, IE で edit mode にアクセスし、「テンプレートの編集」ボタンを押さずに(ウインドウを開かずに)
    # 他のクライアントでメモの作成を行い、更新処理を行わせると、テンプレートウインドウを表示したときに
    # select が表示されない。
    # メモの削除の場合は大丈夫。

    js = render_to_string :update do |page|
      page << "new MemoTemplate(#{template.element_id.to_json}, #{template.name.to_json}, #{template.color.to_json}, #{template.content.to_json});"
      page << "if (!edit_mode) {"
      page << "} else {"
      page << "var selected__ = $F('template_select');"
      page.replace_html "template_select", '<option value="0" id="template_select_none">新規テンプレート</option>'+options_from_collection_for_select(@templates, "id", "name")
      page << "var x = j$('#template_select option[@value=\#{id}]'.interpolate({id:selected__}));"
      page << "x[0].selected = true;"
      page << "}"
    end
    shoot_both js

    render :update do |page|
      page << "new MemoTemplate(#{template.element_id.to_json}, #{template.name.to_json}, #{template.color.to_json}, #{template.content.to_json});"
      page.replace_html "template_select", '<option value="0" id="template_select_none">新規テンプレート</option>'+options_from_collection_for_select(@templates, "id", "name")
      page << "TemplateWindow.edit_mode(#{template.element_id.to_json});"
    end
  end

  def update
    template = Template.find(params[:id])
    template.update_attributes(params[:template])

    render :nothing => true
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
end
