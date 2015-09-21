cat_names = ["Двигатель", "Коробка передач", "Колеса", "Стекла"]

cat_names.each { |name| Category.new(name: name).save }

item_hashes = [*0...40].map do |n|
  {
    name: "Товар #{n}",
    serial: "W10#{rand(4096)}#{n}",
    description: "Consectetur id hic voluptate odit doloribus quaerat autem dignissimos laborum aliquid expedita eum eos perspiciatis asperiores nisi.",
    price: rand(50000)
    }
end
item_hashes.each do |ih|
  Category.order('RANDOM()').first.items.build(ih).save
end
