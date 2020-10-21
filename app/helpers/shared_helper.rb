module SharedHelper
  include ApplicationHelper

  # For error messages in alert
  def inflectize(n, noun)
    if n == 1
      noun
    else
      noun.pluralize
    end
  end

  def description_snippet(description, len=100)
    unless description.blank?
      doc = Nokogiri::HTML::DocumentFragment.parse description
      doc.css("h1,h2,h3,h4,h5,h6").each {|h| h.name = 'h5'}
      doc.css('img').remove
      doc.css('br').remove
      #doc.to_html.truncate(len)
      doc.to_html
    end
  end

  def pic_snippet(description)
    unless description.blank?
      pic_node = Nokogiri::HTML(description).at_css('img')
      pic_node[:src] unless pic_node.nil?
    end
  end

  def conditional_link_to(text=nil, path, cond, **opts, &block)
    if cond
      content_tag(:a, opts.merge(href: path)) { block_given? ? block.call : text }
    else
      opts.delete(:data)
      content_tag(:a, opts.merge(disabled: "disabled")) { block_given? ? block.call : text }
    end
  end

end