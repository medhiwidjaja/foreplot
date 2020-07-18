class AssayService
  attr_reader :criterion, :assay

  def initialize(criterion)
    @criterion = criterion
    @assay = Assay.find_or_initialize_by criterion_id: @criterion.id
  end

  def find_or_initialize
    assay
  end

  def direct_comparisons
    criterion.evaluatees.each do |evaluatee|
      assay.direct_comparisons.find_or_initialize_by comparable: evaluatee
    end
    assay.direct_comparisons
  end
end