# :nocov:

module ApplicationHelper
  def bootstrap_class_for(level)
    styles = {
      notice: 'alert alert-info',
      success: 'alert alert-success',
      error: 'alert alert-danger',
      alert: 'alert alert-danger',
      recaptcha_error: 'alert alert-danger'
    }

    styles[level]
  end

  def flash_messages
    css = 'mx-auto w-50 text-center'

    flash.each do |msg_type, message|
      next if msg_type == 'timedout'

      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type.to_sym)} #{css}") do
        concat message
      end)
    end

    nil
  end
end
