class BaseForm
  include ActiveModel::Model
  include Rails.application.routes.url_helpers
  
  validate :validate_models

  attr_accessor :models
  attr_reader   :appraisal

  def initialize(appraisal, params = {})
    @appraisal = appraisal
    super(params)
  end

  def rest_method
    appraisal.persisted? ? :patch : :post
  end

  def redirect_url(criterion)
    comparable(criterion) == 'Criterion' ? 
        criterion_path(criterion)
      : criterion_ratings_path(criterion)
  end

  private

  def promote_errors(model)
    model.errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def validate_models
    models.each do |model|
      promote_errors(model) if model.invalid?
    end
  end

  def comparable(criterion)
    criterion.children.exists? ? 'Criterion' : 'Alternative'
  end

end