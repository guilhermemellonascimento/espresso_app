# :nocov:

ActionView::Base.field_error_proc = proc do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input')

  html = if field
           error_message = instance_tag.error_message[0]
           field['class'] = "#{field['class']} is-invalid"
           html = <<-HTML
              #{fragment.to_s}
              <div class="invalid-feedback">#{error_message.upcase_first}</div>
           HTML
           html
         else
           html_tag
         end

  html.html_safe
end
