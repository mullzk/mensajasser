module ApplicationHelper
  def short_date(date)
    date.strftime("%d.%m.%y")
  end

  def short_month(date)
    date.strftime("%B %Y")
  end

  
  def n(decimals, number)
    if number && number.to_f != 0
      "%.#{decimals}f" % number
    end    
  end
  
  def d0(number)
    if number && number.to_f > 0
      "%i" % number
    end
  end
  
  def d2(number)
    if number && number.to_f > 0
      "%.2f" % number
    end    
  end
  
  def cyc_color_class
    raw "class=\"#{cyc_color}\""
  end
  
  def cyc_color
    cycle("color_silver", "color_blue", "color_green", "color_yellow", "color_red", :name => "colors")
  end
end
