require 'rails_helper'

RSpec.describe ScrapConcertsJob, type: :job do
  it 'gets the news page' do
    stub = stub_request(:get, 'cheapthrills.ca/news.html')

    ScrapConcertsJob.perform_now

    expect(stub).to have_been_requested.once

    WebMock.reset!
  end

  context 'after scraping the page' do
    let(:expected_concert) { build(:concert, artist: 'YOUNG RIVAL / WE ARE MONROE', datetime: Time.new(2016, 1, 28, 20, 0, 0), venue: 'Belmont', price: 12.0) }

    before {
      VCR.use_cassette(:ct_news) do
        ScrapConcertsJob.perform_now
      end
    }

    subject { Concert.first }

    it 'extracts the artist to the model' do
      expect(subject.artist).to eq(expected_concert.artist)
    end

    it 'extracts the datetime to the model' do
      expect(subject.datetime).to eq(expected_concert.datetime)
    end

    it 'extracts the venue to the model' do
      expect(subject.venue).to eq(expected_concert.venue)
    end

    it 'extracts the price to the model' do
      expect(subject.price).to eq(expected_concert.price)
    end
  end
end
