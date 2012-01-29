# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120129001926) do

  create_table "answers", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id", "created_at"], :name => "index_answers_on_question_id_and_created_at"
  add_index "answers", ["user_id", "created_at"], :name => "index_answers_on_user_id_and_created_at"

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "accepted_answer_id"
  end

  add_index "questions", ["user_id", "created_at"], :name => "index_questions_on_user_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["user_name"], :name => "index_users_on_user_name", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["answer_id", "created_at"], :name => "index_votes_on_answer_id_and_created_at"
  add_index "votes", ["user_id", "created_at"], :name => "index_votes_on_user_id_and_created_at"

end
