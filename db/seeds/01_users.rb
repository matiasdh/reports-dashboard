Faker::Config.random = Random.new(42)
now = Time.current

users = 15.times.map do |i|
  {
    name: Faker::Name.name,
    email: Faker::Internet.email(name: "user_#{i}"),
    created_at: now,
    updated_at: now
  }
end

User.upsert_all(users, unique_by: :index_users_on_lowercase_email)

puts "Seeded #{User.count} users"
