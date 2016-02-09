require "spec_helper"

describe "concerts/index.html.haml" do
  let(:test_concerts) {[
    create(:concert, artist: 'Test Artist'),
    create(:concert, artist: 'Another Test Artist')
  ]}

  before { assign(:concerts, test_concerts) }

  it "displays all the concerts" do
    render

    expect(rendered).to match(/#{test_concerts[0].artist}/i)
    expect(rendered).to match(/#{test_concerts[1].artist}/i)
  end
end
