100.times do
  Product.create(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Random.rand(1000) + 10
    )
end
