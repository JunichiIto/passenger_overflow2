Factory.define :user do |user|
  user.user_name "junichiito"
end

Factory.sequence :user_name do |n|
  "person#{n}"
end

Factory.define :question do |question|
  question.title "my title"
  question.content "Foo bar"
  question.association :user
  question.accepted_answer nil
end

Factory.define :answer do |answer|
  answer.content "Foo bar"
  answer.association :user
  answer.association :question
end
