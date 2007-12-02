module MemosHelper
  def date date
    h date.strftime("%Y年%m月%d日 %H:%M")
  end
end
