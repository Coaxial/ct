require 'rails_helper'

RSpec.describe ScrapConcertsJob, type: :job do
  it 'gets the news page' do
    stub = stub_request(:get, 'cheapthrills.ca/news.html')

    ScrapConcertsJob.perform_now

    expect(stub).to have_been_requested.once

    WebMock.reset!
  end

  it 'extracts concerts to the model' do
    expected_data = {
      artist: 'YOUNG RIVAL / WE ARE MONROE',
      datetime: Time.new(2016, 1, 28, 20, 0, 0),
      venue: 'Belmont',
      price: 12.0
    }

    VCR.use_cassette(:ct_news) do
      ScrapConcertsJob.perform_now
    end

    actual_data = {
      artist: Concert.first.artist,
      datetime: Concert.first.datetime,
      venue: Concert.first.venue,
      price: Concert.first.price
    }

    expect(expected_data).to eq(actual_data)
  end
end
