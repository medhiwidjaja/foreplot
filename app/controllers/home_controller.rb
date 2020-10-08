class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index  
    @featured_articles = Article.public_articles
  end
end
