Factory.define :user do |user|
  user.user_name "junichiito"
end

Factory.define :question do |question|
  question.title "my title"
  question.content "Foo bar"
  question.association :user
end
