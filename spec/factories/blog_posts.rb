# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blog_post do
    title "MyString"
    content "MyString"
    author_id 1
    published_at "2014-02-10 15:15:01"
  end
end
