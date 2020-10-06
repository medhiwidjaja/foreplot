module ApplicationHelper

  def logo
    image_tag("foreplot.png", alt: "FOREPLOT")
  end
  
  # For layout
  def has_left_frame?
    @has_left_frame.nil? ? 
      true : # <= default, change to preference
      @has_left_frame
  end

  def has_right_frame?
    @has_right_frame.nil? ? 
      true : # <= default, change to preference
      @has_right_frame
  end

  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end
end
