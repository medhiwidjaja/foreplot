SELECT criteria.id, criteria.title, criteria.parent_id, children, appraisals.id as apid, member_id, 
	appraisals.appraisal_method, is_complete, subnodes,
	cmp.score, cmp.comparable_type, cmp.comparable_id
FROM criteria
LEFT OUTER JOIN appraisals ON criteria.id = appraisals.criterion_id AND appraisals.is_valid = true AND appraisals.member_id = 8
LEFT OUTER JOIN comparisons cmp ON cmp.appraisal_id = appraisals.id 
LEFT OUTER JOIN (
SELECT DISTINCT c.parent_id AS id, array_agg(c.id) OVER (PARTITION BY parent_id) AS children,
array_agg(a.id) OVER (PARTITION BY parent_id) as subnodes
FROM criteria c LEFT OUTER JOIN appraisals a ON a.criterion_id = c.id ) pc ON criteria.id = pc.id
WHERE criteria.article_id = 9
ORDER BY criteria.id