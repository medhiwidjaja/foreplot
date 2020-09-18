class AHPComparison < Comparison

  Need to handle joins with polymorphic relation
  scope :order_by_position, -> {
    joins(<<-SQL.squish
      LEFT OUTER JOIN criteria c
      ON c.id = comparisons.comparable_id 
      AND comparisons.comparable_type = 'Criterion'

      LEFT OUTER JOIN alternatives a
      ON a.id = comparisons.comparable_id 
      AND comparisons.comparable_type = 'Alternative'
    SQL
    )
    .select(<<-SQL.squish
       comparisons.*,
       CASE WHEN a.id IS NULL THEN COALESCE(c.position, c.id)
            WHEN c.id IS NULL THEN COALESCE(a.position, a.id)
            ELSE NULL
       END AS position,
       CASE WHEN a.id IS NULL THEN COALESCE(c.title, '')
            WHEN c.id IS NULL THEN COALESCE(a.title, '')
            ELSE NULL
       END AS name
    SQL
    )
    .order('position ASC')
  }

end