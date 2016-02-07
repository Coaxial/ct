require 'open-uri'

class ScrapConcertsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    parse_html
  end

  private
  def news_page_html
    open('http://cheapthrills.ca/news.html')
  end

  def parse_html
    news_page = Nokogiri::HTML(news_page_html)
  end
end
