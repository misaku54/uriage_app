FactoryBot.define do
  factory :user do
    name { 'Example User' }
    email { 'user@example.com' }
    password { 'password' }
    password_confirmation { 'password' }

    trait :users do
      sequence(:name) { |n| "Example User#{n}" }
      sequence(:email) { |n| "user@example#{n}.com" }
    end
  end

  factory :admin_user, class: User do
    name { 'Admin User' }
    email { 'admin@example.com' }
    admin { true }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :valid_user, class: User do
    name { 'Valid User' }
    email { 'validuser@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :invalid_user, class: User do
    name { '' }
    email { 'user@invalid' }
    password { 'foo' }
    password_confirmation { 'bar' }
  end

  factory :jhon, class: User do
    name { 'Test Jhon' }
    email { 'jhon@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
