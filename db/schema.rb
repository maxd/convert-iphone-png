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

ActiveRecord::Schema.define(:version => 20120718201229) do

  create_table "pictures", :force => true do |t|
    t.string   "png_file_file_name"
    t.string   "png_file_content_type"
    t.integer  "png_file_file_size"
    t.datetime "png_file_updated_at"
    t.string   "group",                 :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

end
