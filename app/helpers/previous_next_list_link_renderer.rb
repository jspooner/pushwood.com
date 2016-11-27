class PreviousNextListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  def to_html
    html = previous_page
    html += "<span class=\"center\">#{current_page} of #{@collection.total_pages} photos</span>"
    html += next_page
  end

  protected
  
    def url(page)
      "#{@template.request.path}?page=#{page}"
    end
    
    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], 'btn btn-mini pull-left')
    end
    
    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], 'btn btn-mini pull-right')
    end
    
    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :class => classname)
      else
        tag(:span, text, :class => classname + ' disabled')
      end
    end
          
end