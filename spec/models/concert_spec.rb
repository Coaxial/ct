require 'rails_helper'

RSpec.describe Concert, type: :model do
  it "is not valid without an artist" do
    subject = build(:concert, :no_artist)
    expect(subject.valid?).to be false
  end
  it "is not valid without a datetime" do
    subject = build(:concert, :no_datetime)
    expect(subject.valid?).to be false
  end
  it "is not valid without a venue" do
    subject = build(:concert, :no_venue)
    expect(subject.valid?).to be false
  end
  it "is not valid without a price" do
    subject = build(:concert, :no_price)
    expect(subject.valid?).to be false
  end
end
