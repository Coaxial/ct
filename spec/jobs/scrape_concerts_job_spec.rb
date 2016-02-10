require 'rails_helper'

RSpec.describe ScrapeConcertsJob, type: :job do

  context 'when running' do
    it 'gets the news page' do
      stub = stub_request(:get, 'cheapthrills.ca/news.html')
      ScrapeConcertsJob.perform_now

      expect(stub).to have_been_requested.once

      WebMock.reset!
    end
  end

  context 'after scraping the page' do
    before {
      VCR.use_cassette(:ct_news) do
        ScrapeConcertsJob.perform_now
      end
    }

    let(:expected_concert) { build(:concert, artist: 'KURT VILE & THE VIOLATORS', datetime: Time.new(2016, 2, 20, 20, 30, 0), venue: 'Corona', price: 27.0, soldout: true) }

    subject { Concert.find_by({ artist: 'KURT VILE & THE VIOLATORS' }) }

    attributes = [:artist, :datetime, :venue, :price, :soldout]
    attributes.each do |attribute|
      it "extracts the #{attribute} to the model" do
        expect(subject[attribute]).to eq(expected_concert[attribute])
      end
    end
  end
end
