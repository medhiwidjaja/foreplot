WITH table1 as (
SELECT DISTINCT c.parent_id AS id, 
	array_agg(c.id) OVER (PARTITION BY parent_id) AS children
FROM criteria c 
WHERE c.article_id = 9
)
SELECT DISTINCT c.id, c.title, cmp.comparable_type, cmp.comparable_id as comparable, cmp.score, cmp.id as cmpid, table1.children,
	array_agg(cmp.comparable_id) OVER (PARTITION BY a.id) as leafnodes
FROM criteria c 
LEFT OUTER JOIN appraisals a ON a.criterion_id = c.id 
LEFT OUTER JOIN comparisons cmp ON cmp.appraisal_id = a.id AND a.is_valid = true AND a.member_id = 8
LEFT OUTER JOIN table1 ON table1.id = c.id
WHERE c.article_id = 9
