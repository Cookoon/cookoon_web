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

ActiveRecord::Schema.define(version: 2019_08_28_082058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachinary_files", force: :cascade do |t|
    t.string "attachinariable_type"
    t.bigint "attachinariable_id"
    t.string "scope"
    t.string "public_id"
    t.string "version"
    t.integer "width"
    t.integer "height"
    t.string "format"
    t.string "resource_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent"
    t.index ["attachinariable_type", "attachinariable_id"], name: "index_attachinary_files_on_attachinariable_type"
  end

  create_table "availabilities", force: :cascade do |t|
    t.boolean "available", default: false
    t.bigint "cookoon_id"
    t.date "date"
    t.integer "time_slot"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cookoon_id"], name: "index_availabilities_on_cookoon_id"
  end

  create_table "chefs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "siren"
    t.bigint "siret"
    t.string "vat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.string "referent_email"
    t.string "stripe_bank_name"
    t.string "stripe_bic"
    t.string "stripe_iban"
  end

  create_table "cookoons", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.integer "surface"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.string "address"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "category"
    t.text "description"
    t.integer "status", default: 0
    t.string "digicode"
    t.string "building_number"
    t.string "floor_number"
    t.string "door_number"
    t.string "wifi_network"
    t.string "wifi_code"
    t.text "caretaker_instructions"
    t.string "pdf_url"
    t.string "address_complement"
    t.integer "capacity_standing"
    t.text "recommended_uses"
    t.text "perks_complement"
    t.string "architect_name"
    t.index ["user_id"], name: "index_cookoons_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "reservation_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "checkin_at"
    t.datetime "checkout_at"
    t.text "remark"
    t.index ["reservation_id"], name: "index_inventories_on_reservation_id"
  end

  create_table "menus", force: :cascade do |t|
    t.bigint "chef_id"
    t.string "description"
    t.integer "unit_price_cents", default: 0, null: false
    t.string "unit_price_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chef_id"], name: "index_menus_on_chef_id"
  end

  create_table "perk_specifications", force: :cascade do |t|
    t.string "name"
    t.string "icon_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perks", force: :cascade do |t|
    t.bigint "cookoon_id"
    t.bigint "perk_specification_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cookoon_id"], name: "index_perks_on_cookoon_id"
    t.index ["perk_specification_id"], name: "index_perks_on_perk_specification_id"
  end

  create_table "pro_quote_cookoons", force: :cascade do |t|
    t.bigint "pro_quote_id"
    t.bigint "cookoon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cookoon_id"], name: "index_pro_quote_cookoons_on_cookoon_id"
    t.index ["pro_quote_id"], name: "index_pro_quote_cookoons_on_pro_quote_id"
  end

  create_table "pro_quote_services", force: :cascade do |t|
    t.bigint "pro_quote_id"
    t.integer "category", default: 0, null: false
    t.integer "quantity"
    t.index ["pro_quote_id"], name: "index_pro_quote_services_on_pro_quote_id"
  end

  create_table "pro_quotes", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.bigint "user_id"
    t.bigint "company_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "duration"
    t.integer "people_count"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_pro_quotes_on_company_id"
    t.index ["user_id"], name: "index_pro_quotes_on_user_id"
  end

  create_table "pro_reservations", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.bigint "pro_quote_id"
    t.bigint "cookoon_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "duration"
    t.integer "people_count"
    t.integer "cookoon_price_cents", default: 0, null: false
    t.integer "services_price_cents", default: 0, null: false
    t.integer "cookoon_fee_cents", default: 0, null: false
    t.integer "total_full_price_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "requested_modification"
    t.integer "cookoon_fee_tax_cents", default: 0, null: false
    t.integer "services_tax_cents", default: 0, null: false
    t.integer "total_price_cents", default: 0, null: false
    t.integer "services_full_price_cents", default: 0, null: false
    t.string "stripe_charge_id"
    t.integer "total_tax_cents", default: 0, null: false
    t.index ["cookoon_id"], name: "index_pro_reservations_on_cookoon_id"
    t.index ["pro_quote_id"], name: "index_pro_reservations_on_pro_quote_id"
  end

  create_table "pro_service_specifications", force: :cascade do |t|
    t.string "name"
    t.integer "unit_price_cents", default: 0, null: false
    t.string "unit_price_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pro_services", force: :cascade do |t|
    t.bigint "pro_reservation_id"
    t.string "name"
    t.integer "quantity"
    t.integer "unit_price_cents", default: 0, null: false
    t.string "unit_price_currency", default: "EUR", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_reservation_id"], name: "index_pro_services_on_pro_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "cookoon_id"
    t.bigint "user_id"
    t.datetime "start_at"
    t.integer "duration"
    t.integer "price_cents"
    t.string "price_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.boolean "cleaning", default: false
    t.boolean "janitor", default: false
    t.string "stripe_charge_id"
    t.datetime "end_at"
    t.integer "people_count"
    t.text "message_for_host"
    t.string "aasm_state"
    t.boolean "paid", default: false
    t.integer "category", default: 0
    t.string "type_name"
    t.integer "cookoon_price_cents", default: 0, null: false
    t.integer "cookoon_fee_cents", default: 0, null: false
    t.integer "cookoon_fee_tax_cents", default: 0, null: false
    t.integer "services_price_cents", default: 0, null: false
    t.integer "services_tax_cents", default: 0, null: false
    t.integer "services_full_price_cents", default: 0, null: false
    t.integer "total_tax_cents", default: 0, null: false
    t.integer "total_price_cents", default: 0, null: false
    t.integer "total_full_price_cents", default: 0, null: false
    t.bigint "menu_id"
    t.index ["cookoon_id"], name: "index_reservations_on_cookoon_id"
    t.index ["menu_id"], name: "index_reservations_on_menu_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "reservation_id"
    t.integer "price_cents"
    t.string "price_currency", default: "EUR", null: false
    t.integer "status", default: 0, null: false
    t.string "stripe_charge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0, null: false
    t.boolean "payment_tied_to_reservation", default: false
    t.string "name"
    t.integer "quantity"
    t.integer "unit_price_cents", default: 0, null: false
    t.index ["reservation_id"], name: "index_services_on_reservation_id"
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
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.text "description"
    t.string "phone_number"
    t.string "stripe_account_id"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "stripe_customer_id"
    t.boolean "admin", default: false
    t.integer "emailing_preferences", default: 1
    t.date "born_on"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "availabilities", "cookoons"
  add_foreign_key "cookoons", "users"
  add_foreign_key "inventories", "reservations"
  add_foreign_key "menus", "chefs"
  add_foreign_key "perks", "cookoons"
  add_foreign_key "perks", "perk_specifications"
  add_foreign_key "pro_quote_cookoons", "cookoons"
  add_foreign_key "pro_quote_cookoons", "pro_quotes"
  add_foreign_key "pro_quote_services", "pro_quotes"
  add_foreign_key "pro_quotes", "companies"
  add_foreign_key "pro_quotes", "users"
  add_foreign_key "pro_reservations", "cookoons"
  add_foreign_key "pro_reservations", "pro_quotes"
  add_foreign_key "pro_services", "pro_reservations"
  add_foreign_key "reservations", "cookoons"
  add_foreign_key "reservations", "menus"
  add_foreign_key "reservations", "users"
  add_foreign_key "services", "reservations"
  add_foreign_key "users", "companies"
end
