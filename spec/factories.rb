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
end

Factory.define :answer do |answer|
  answer.content "Foo bar"
  answer.association :user
  answer.association :question
end

Factory.define :vote do |vote|
  vote.association :user
  vote.association :answer
end

Factory.define :reputation do |r|
  r.association :activity, factory: :vote
  r.association :user
  r.reason "voteup"
  r.point 10
end

