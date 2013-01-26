module ApplicationHelper
  
  def format_time(time)
    return '' unless time
    return time.strftime("%Y-%m-%d %H:%M:%S")
  end
  
end
