require 'open-uri'

class ScrapeConcertsJob < ActiveJob::Base
  queue_as :default

  def perform
    raw_concerts = get_webpage_data
    concerts = parse raw_concerts
    save_to_model concerts
  end

  private
  def news_page_html
    open('http://cheapthrills.ca/news.html')
  end

  def split(concert_data)
    split_concert_data = concert_data.text.split("\r\n")
    split_concert_data.reject { |string| string.blank? }
  end
  
  def parse(raw_concerts)
    parsed_concerts = raw_concerts.map do |raw_concert|
      # If the concert is sold out, "SOLD OUT" is the first element of the array and the array
      # contains 6 elements instead of 5.
      # It's cleaner to deal with a boolean that will be present for every record so we have
      # to do the normalizing ourselves
      is_soldout = (raw_concert.length === 6 && !!(raw_concert[0].match(/sold\s?out/i)))
      concert_with_soldout_status = raw_concert.insert(0, is_soldout)
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
  end

  def save_to_model(concerts)
    Concert.create(concerts)
  end

  def get_webpage_data
    news_page_data = Nokogiri::HTML(news_page_html) do |config|
      config.nonet
    end

    concerts_selector = 'body > center > table table tr'
    concerts_data = news_page_data.css(concerts_selector)
    list_header_index = 0

    raw_concerts = concerts_data.map.with_index do |concert_data, index|
      next if index === list_header_index
      split concert_data
    end

    # next returns nil
    raw_concerts.compact
  end
end
