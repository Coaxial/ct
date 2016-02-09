require 'rails_helper'

RSpec.describe GetArtistSampleJob, type: :job do
  it 'contacts the SoundCloud API' do
    stub = stub_request(:get, 'https://api.spotify.com')
    GetArtistSampleJob.perform_now

    expect(stub).to have_been_requested.once

    WebMock.reset!
  end
end
