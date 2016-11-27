require 'open-uri'
class CdPage < ActiveRecord::Base

  has_many :locations

  validates_presence_of :guid, :url
  validates_uniqueness_of :url

  serialize :data

  # Todo. Phone email, url, metal surface
  # http://www.concretedisciples.com/categories/58-usa-skateparks/21025
  def self.parse_remote(id)
    url                = "http://www.concretedisciples.com/categories/58-usa-skateparks/#{id}"
    logger.info { "Importing #{url}" }
    detail             = Hpricot( open (url) )
    data               = Hash.new
    description        = detail.search("meta[@name=description]").attr('content')
    items              = description.split("-")
    items.delete_at 0
    data[:title]       = items[0]
    data[:street]      = detail.search("#jwts_tab").inner_html.to_s[/^Address:(.*)<br/]
    data[:city]        = items[1].split(",")[0] if items[1]
    data[:state]       = items[1].split(",")[1] if items[1]
    data[:lights]      = (items[2] =~ /lights=Yes/) ? true : false
    data[:concrete]    = (items[2] =~ /surface is Concrete/) ? true : false
    data[:outdoors]    = (items[2] =~ /Outside/) ? true : false
    data[:free]        = (items[2] =~ /Free/) ? true : false
    data[:images]      = detail.search("img").collect { |i| i.attributes['src'] }
    data[:description] = detail.search(".contentFulltext").inner_text    
    data[:phone]       = detail.search("#jwts_tab").inner_html.to_s[/^Phone #:(.*)<br/,1]
    data[:url]         = detail.search("#jwts_tab").inner_html.to_s[/^Website Address:(.*)<br/,1]
    data[:email]       = detail.search("#jwts_tab").inner_html.to_s[/^Email:(.*)<br/]
    
    self.create({:url => url, :guid => id, :data => data})
  rescue StandardError => e
    logger.error { "ERROR #{e.inspect}" }
  # rescue OpenURI::HTTPError => e
  #   logger.info { "404 #{url}" }    
  end
  
end


