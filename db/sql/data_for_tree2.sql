WITH table1 as (
SELECT DISTINCT c.id, c.title, c.parent_id, cmp.comparable_type as type, array_agg(cmp.comparable_id) OVER (PARTITION BY a.id) as children
FROM criteria c LEFT OUTER JOIN appraisals a ON a.criterion_id = c.id 
LEFT OUTER JOIN comparisons cmp ON cmp.appraisal_id = a.id AND a.member_id = 8
WHERE c.article_id = 9
)
SELECT table1.id, table1.title, table1.parent_id, 'Criterion', table1.children, table1.id || '-' || 'Criterion' as idx
FROM table1
UNION
SELECT a.id, a.title, NULL, 'Alternative', array[]::bigint[], a.id || '-' || 'Alternative'
FROM alternatives a,  table1
WHERE a.id = ANY(table1.children)
