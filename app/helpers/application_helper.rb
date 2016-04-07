module ApplicationHelper

  def fix_url_format(url)
    if url.match(/https?:\/{2}.+/)
      url
    else
      "http://" + url
    end
  end

  def fix_date_time_format(date_time)
    if logged_in? && !current_user.timezone.blank?
      date_time.in_time_zone(current_user.timezone).strftime("%l:%M%P %Z on %-m/%e/%Y")
    else
      date_time.strftime("%l:%M%P %Z on %-m/%e/%Y")
    end
  end
end
