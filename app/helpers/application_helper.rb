module ApplicationHelper
  def fix_url_format(url)
    if url.match(/https?:\/{2}.+/)
      url
    else
      "http://" + url
    end
  end

  def fix_date_time_format(date_time)
    date_time.localtime.strftime("%l:%M%P %Z on %-m/%e/%Y")
  end
end
