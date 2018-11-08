module ApplicationHelper
  def short_date(date)
    date.strftime("%d.%m.%y")
  end

  def short_month(date)
    date.strftime("%B %Y")
  end

  def format_number(number)
    if number && number > 0
      if number.class == Integer
        "%i" % number
      else
        "%.2f" % number
      end
    end
  end
    
  
   
  def cyc_color_class
    raw "class=\"#{cyc_color}\""
  end
  
  def cyc_color
    cycle("color_silver", "color_blue", "color_green", "color_yellow", "color_red", :name => "colors")
  end
end
