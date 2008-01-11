class NotepadContentsController < ApplicationController
  def update
    NotepadContent.set(params[:body])

    js = render_to_string :update do |page|
      page << "Notepad.set(#{params[:body].to_json});"
    end
    shoot_both js

    render :nothing => true
  end
end
