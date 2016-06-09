300.times do
  Question.create title:      Faker::Company.bs,
                  body:       Faker::Hipster.paragraph,
                  view_count: rand(100)
end

puts Cowsay.say "Generated 300 questions!"
