ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')
  elements.each do |e|
    if e.node_name.eql? 'label'
      html = %(<div class="control-group error">#{e}</div>).html_safe
    elsif form_fields.include?(e.node_name)
      e['class'] ||= ""
      e['class'] = e['class'] << " is-invalid"
      if e['class'].include?('sans-err-msg')
        html = %(#{e}).html_safe
      else
        if instance.error_message.kind_of?(Array)
          html = %(#{e}<div class="invalid-feedback">#{instance.error_message.first}</div>).html_safe
        else
          html = %(#{e}<div class="invalid-feedback">#{instance.error_message}</div>).html_safe
        end
      end
    end
  end
  html
end

