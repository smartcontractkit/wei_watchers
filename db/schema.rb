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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161216072621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "address"
    t.decimal  "balance",    precision: 24, default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "balance_subscriptions", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "subscriber_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "end_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "event_subscription_notifications", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "filter_config_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_subscriptions", force: :cascade do |t|
    t.integer  "subscriber_id"
    t.integer  "filter_config_id"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filter"
  end

  create_table "event_topics", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "block_hash"
    t.integer  "block_number"
    t.string   "data"
    t.integer  "log_index"
    t.string   "transaction_hash"
    t.integer  "transaction_index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filter_configs", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "from_block"
    t.integer  "to_block"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filter_topics", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "filter_config_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", force: :cascade do |t|
    t.text     "notification_url"
    t.string   "xid"
    t.string   "api_key"
    t.string   "notifier_id"
    t.string   "notifier_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string   "topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
