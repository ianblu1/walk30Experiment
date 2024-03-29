# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130129160836) do

  create_table "message_strategies", :force => true do |t|
    t.integer  "strategy_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "project_message_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "participant_id"
    t.string   "subject"
    t.string   "content"
    t.integer  "medium"
    t.integer  "status"
    t.datetime "scheduled_at"
    t.datetime "sent_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "flag"
    t.string   "type"
  end

  add_index "messages", ["participant_id", "sent_at", "scheduled_at"], :name => "index_messages_on_participant_id_and_sent_at_and_scheduled_at"

  create_table "participants", :force => true do |t|
    t.string   "email"
    t.integer  "age"
    t.string   "zip_code"
    t.boolean  "is_male"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "phone"
    t.integer  "status"
    t.datetime "experiment_begun_at"
    t.datetime "experiment_ended_at"
    t.boolean  "morning_reminder"
    t.integer  "walked_last_week",    :default => 0
    t.string   "type"
    t.string   "time_zone",           :default => "PST"
    t.string   "reminder_strategy",   :default => "ian_reminder_strategy"
  end

  add_index "participants", ["email"], :name => "index_participants_on_email", :unique => true
  add_index "participants", ["phone"], :name => "index_participants_on_phone", :unique => true

  create_table "strategies", :force => true do |t|
    t.boolean  "morning"
    t.string   "time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
