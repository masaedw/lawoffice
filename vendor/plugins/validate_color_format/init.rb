module ValidateColorFormat
  def validates_color_format_of sym, option = { }
    option.update(:with => /^#[0-9a-f]{3}{1,2}$/i)
    validates_format_of(sym, option)
  end
end

ActiveRecord::Base.extend(ValidateColorFormat)
