class FormBase
  include ActiveModel::Model

  attr_accessor :models
  validate :validate_models

  def initialize(params = {})
    super(params)
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
end
