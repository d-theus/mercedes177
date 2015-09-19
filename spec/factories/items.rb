FactoryGirl.define do
  sequence(:name) { |n| %w(какая-то просто супер)[n%3] + 'деталь'}
  sequence(:serial) { |n| "W1000#{n*300 + n}"}
  sequence(:description) { |n| Forgery::LoremIpsum.paragraphs(1)}
  sequence(:price) { |n| n + rand(300)*0.52 }
  sequence(:count)

  factory :item do
    name "Item"

    name
    serial
    description
    price
    count
  end

end
