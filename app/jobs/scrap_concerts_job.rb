require 'open-uri'

class ScrapConcertsJob < ActiveJob::Base
  queue_as :default

  def perform
    extract_concert_data
  end

  after_perform do |job|
    GetArtistSampleJob.perform_later
  end

  private
  def news_page_html
    open('http://cheapthrills.ca/news.html')
  end

  def split_data(data)
    split_data = data.text.split("\r\n")
    split_data.reject { |string| string.blank? }
  end
  
  def parse_concert(concert_data)
    # If the concert is sold out, "SOLD OUT" is the first element of the araray.
    # It's cleaner to deal with a boolean that will be there for every record so we have
    # to do the normalizing ourselves
    is_soldout = (concert_data.length === 6 && !!(concert_data[0].match(/sold\s?out/i)))
    concert_with_soldout_status = concert_data.insert(0, is_soldout)
    concert_with_soldout_status.slice!(1) if is_soldout

    date = Date.parse(concert_with_soldout_status[2])
    time = Time.parse(concert_with_soldout_status[3])
    datetime = Time.new(date.year, date.month, date.day, time.hour, time.min)
    price = concert_with_soldout_status[5].gsub(/[^\d\.]/, '')

    {
      artist: concert_with_soldout_status[1],
      datetime: datetime,
      venue: concert_with_soldout_status[4],
      price: price,
      soldout: is_soldout
    }
  end

  def extract_concert_data
    news_page = Nokogiri::HTML(news_page_html) do |config|
      config.nonet
    end

    concerts_selector = 'body > center > table table tr'
    concerts_data = news_page.css(concerts_selector)
    list_header_index = 0

    concerts = concerts_data.map.with_index do |concert_data, index|
      next if index === list_header_index
      split_concert_data = split_data concert_data
      parse_concert split_concert_data
    end

    Concert.create(concerts)
  end
end
