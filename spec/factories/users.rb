FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
  
  factory :invalid_user, class: User do 
    name { "" }
    email { "user@invalid" }
    password { "foo" }
    password_confirmation { "bar" }
  end

  factory :jhon, class: User do
    name { "Test Jhon" }
    email { "jhon@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
