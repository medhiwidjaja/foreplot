class AddArticleIdInCriteria < ActiveRecord::Migration[5.2]
  def change
    add_reference :criteria, :article, foreign_key: true
  end
end
