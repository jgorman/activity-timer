# frozen_string_literal: true

class BaseSchema < ActiveRecord::Migration[6.0]
  def self.up
    create_table "activities", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "client_id", null: false
      t.bigint "project_id", null: false
      t.datetime "start", null: false
      t.integer "length", default: 0, null: false
      t.string "name", default: "", null: false
      t.index ["client_id", "start"], name: "index_activities_on_client_id_and_start"
      t.index ["project_id", "start"], name: "index_activities_on_project_id_and_start"
      t.index ["user_id", "start"], name: "index_activities_on_user_id_and_start"
    end

    create_table "clients", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.string "name", default: "", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["user_id", "name"], name: "index_clients_on_user_id_and_name", unique: true
    end

    create_table "projects", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "client_id", null: false
      t.string "name", default: "", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.integer "color", default: 0, null: false
      t.index ["client_id", "name"], name: "index_projects_on_client_id_and_name", unique: true
      t.index ["user_id"], name: "index_projects_on_user_id"
    end

    create_table "timers", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "project_id", null: false
      t.datetime "start", null: false
      t.string "name", default: "", null: false
      t.index ["user_id"], name: "index_timers_on_user_id", unique: true
    end

    create_table "users", force: :cascade do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string "unconfirmed_email"
      t.integer "failed_attempts", default: 0, null: false
      t.string "unlock_token"
      t.datetime "locked_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "role_s"
      t.string "first_name"
      t.string "last_name"
      t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    end
  end
end
