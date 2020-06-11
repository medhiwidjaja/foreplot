json.extract! article, :id, :title, :description, :likes, :slug, :private, :active, :created_at, :updated_at
json.url article_url(article, format: :json)
