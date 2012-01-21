namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:user_name => "junichiito")
    99.times do |n|
      name  = Faker::Name.name
      user_name = name.gsub(/[^A-Za-z0-9]/, '').downcase[0, 20]
      User.create!(:user_name => user_name)
    end
  end
end
