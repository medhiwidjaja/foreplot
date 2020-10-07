class HomeController < ApplicationController
  def index  
    @featured_articles = Article.public_articles
  end
end
