require 'rails_helper'

RSpec.describe ScrapConcertsJob, type: :job do
  it 'gets the news page' do
    stub = stub_request(:get, 'cheapthrills.ca/news.html')

    ScrapConcertsJob.perform_now

    expect(stub).to have_been_requested.once

    WebMock.reset!
  end

  it 'extracts concerts to the model' do
    expected_concert = build(:concert, artist: 'YOUNG RIVAL / WE ARE MONROE', datetime: Time.new(2016, 1, 28, 20, 0, 0), venue: 'Belmont', price: 12.0)

    VCR.use_cassette(:ct_news) do
      ScrapConcertsJob.perform_now
    end

    expect(Concert.first).to eq(expected_concert)
  end
end
