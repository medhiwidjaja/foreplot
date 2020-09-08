module ArticlesHelper
  def my_articles
    Article.where(user:current_user)
  end
end
