require "spec_helper"

describe "concerts/index.html.haml" do
  it "displays all the concerts" do
    assign(:concerts, [
      Concert.create!(artist: 'Test artist', datetime: DateTime.new(1969, 7, 23, 4, 53, 0), venue: 'Test venue', price: 777),
      Concert.create!(artist: 'Another test artist', datetime: DateTime.new(1970, 5, 12, 6, 12, 0), venue: 'Another test venue', price: 888)
    ])

    render

    expect(rendered).to match(/Test artist/)
    expect(rendered).to match(/Another test artist/)
  end
end
