class ComparisonFormBase < FormBase
  include Rails.application.routes.url_helpers
  
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

  def comparable(criterion)
    criterion.children.exists? ? 'Criterion' : 'Alternative'
  end

end