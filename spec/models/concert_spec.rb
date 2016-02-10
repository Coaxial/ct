require 'rails_helper'

RSpec.describe Concert, type: :model do
  attributes = [:artist, :datetime, :venue, :price]
  attributes.each do |attribute|
    it "is not valid with a missing #{attribute}" do
      trait = "no_#{attribute}".to_sym
      concert = build(:concert, trait)

      expect(concert.valid?).to be false
    end
  end
end
