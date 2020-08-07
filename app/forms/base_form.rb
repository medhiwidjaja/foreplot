class BaseForm
  include ActiveModel::Model
  
  validate :validate_models

  attr_accessor :models

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

end