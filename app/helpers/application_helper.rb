module ApplicationHelper
  def mobile_device?
    @browser ||= Browser.new(request.user_agent, accept_language: "en-us")
    @browser.device.mobile?
  end

  def months
    %w(January Fabruary March April May June July August September October November December).zip((1..12).to_a)
  end

end
