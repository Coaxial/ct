require 'open-uri'

class ScrapConcertsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Nokogiri::HTML(open("http://cheapthrills.ca/news.html"))
  end
end
