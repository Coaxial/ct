require 'rails_helper'

RSpec.describe ScrapConcertsJob, type: :job do

  context 'when running' do
    it 'gets the news page' do
      stub = stub_request(:get, 'cheapthrills.ca/news.html')
      ScrapConcertsJob.perform_now

      expect(stub).to have_been_requested.once

      WebMock.reset!
    end
  end

  context 'after scraping the page' do
    before {
      VCR.use_cassette(:ct_news) do
        ScrapConcertsJob.perform_now
      end
    }

    let(:expected_concert) { build(:concert, artist: 'KURT VILE & THE VIOLATORS', datetime: Time.new(2016, 2, 20, 20, 30, 0), venue: 'Corona', price: 27.0, soldout: true) }

    subject { Concert.find_by({ artist: 'KURT VILE & THE VIOLATORS' }) }

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

    it 'extracts the soldout status to the model' do
      expect(subject.soldout).to eq(expected_concert.soldout)
    end
  end
end
