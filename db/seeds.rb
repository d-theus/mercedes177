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

names = %w(Андрей Борис Владимир Геннадий Денис Леонид Михаил Николай Родион Эльдар Ян)
lnames = %w(Бесфамильный)
mnames = %w(Батькович)
pcodes = [499, 916, 926, 988]

30.times do 
  Order.create(
    first_name: names.sample,
    last_name: lnames.sample,
    middle_name: mnames.sample,
    address: 'Lorem sint inventore nam cumque veritatis. Fuga minima voluptatum odio quas aliquam eaque optio modi aperiam. Neque accusamus laborum fuga excepturi reiciendis suscipit ab consequatur. Itaque quidem nulla et sunt!',
    phone: "8 #{pcodes.sample} #{(rand()*10000000).to_i}",
    email: 'mail@example.com'
  )
end
