FactoryGirl.define do
  factory :concert do
    artist "The Rolling Stones"
    datetime Time.new(1965, 3, 5, 20, 0, 0)
    venue "Edmonton, Regal Theatre"
    price 30

    trait :no_artist do
      artist nil
    end
    
    trait :no_datetime do
      datetime nil
    end

    trait :no_venue do
      venue nil
    end

    trait :no_price do
      price nil
    end
  end
end
