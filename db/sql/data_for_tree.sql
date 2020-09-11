SELECT DISTINCT c.id, c.title, c.parent_id, cmp.comparable_type as type, (cmp.comparable_type != 'Criterion') as is_leaf, a.is_complete, array_agg(cmp.comparable_id) OVER (PARTITION BY a.id) as children
FROM criteria c LEFT OUTER JOIN appraisals a ON a.criterion_id = c.id 
LEFT OUTER JOIN comparisons cmp ON cmp.appraisal_id = a.id AND a.is_valid = true AND a.member_id = 8
WHERE c.article_id = 9