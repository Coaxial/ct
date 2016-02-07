require 'rails_helper'

RSpec.describe ScrapConcertsJob, type: :job do
  it "gets the page's contents" do
    stub_request(:get, 'cheapthrills.ca/news.html')
    ScrapConcertsJob.perform_now
    expect(WebMock).to have_requested(:get, 'cheapthrills.ca/news.html')
  end
end
