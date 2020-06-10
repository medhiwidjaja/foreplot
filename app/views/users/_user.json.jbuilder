json.extract! user, :id, :name,, :encrypted_password,, :email,, :bio,, :account,, :role, :created_at, :updated_at
json.url user_url(user, format: :json)
