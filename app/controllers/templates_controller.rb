class TemplatesController < ApplicationController
  def create
    template = Template.new(params[:memo])
    template.save

    template = Template.find(:first, :order => 'id DESC')

    @templates = Template.find(:all, :order => 'name')

    # FIXME: IE でエラーになる
    js = render_to_string :update do |page|
      page << "new MemoTemplate(#{template.element_id.to_json}, #{template.name.to_json}, #{template.color.to_json}, #{template.content.to_json});"
      page << "if (!edit_mode) {"
      page << "} else {"
      page << "var selected__ = $F('template_select');"
      page.replace_html "template_select", ""
      page.replace_html "template_select", '<option value="0" id="template_select_none">新規テンプレート</option>'+options_from_collection_for_select(@templates, "id", "name")
      page << "var x = j$('#template_select option[@value=\#{id}]'.interpolate({id:selected__}));"
      page << "x[0].selected = true;"
      page << "}"
    end
    shoot_both js

    render :update do |page|
      page << "new MemoTemplate(#{template.element_id.to_json}, #{template.name.to_json}, #{template.color.to_json}, #{template.content.to_json});"
      page.replace_html "template_select", ""
      page.replace_html "template_select", '<option value="0" id="template_select_none">新規テンプレート</option>'+options_from_collection_for_select(@templates, "id", "name")
      page << "TemplateWindow.edit_mode();"
      page << "TemplateWindow.show(MemoTemplate.find(#{template.element_id.to_json}));"
    end
  end

  def update
  end

  def delete
  end
end
