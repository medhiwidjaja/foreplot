class Comparison < ApplicationRecord
  belongs_to :comparable, polymorphic:true
  belongs_to :appraisal
end
