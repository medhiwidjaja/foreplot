SELECT DISTINCT cmp.comparable_id || '-' || cmp.comparable_type as idx, cmp.id, a.criterion_id as cid, comparable.title, cmp.comparable_id, cmp.comparable_type, cmp.score_n
FROM comparisons cmp
LEFT OUTER JOIN appraisals a ON cmp.appraisal_id = a.id AND a.member_id = 30
LEFT OUTER JOIN criteria comparable ON comparable.id = cmp.comparable_id
LEFT OUTER JOIN criteria c ON c.id = a.criterion_id
WHERE c.article_id = 28 AND cmp.comparable_type = 'Criterion'
UNION
SELECT DISTINCT cmp.comparable_id || '-' || cmp.comparable_type as idx, cmp.id, a.criterion_id as cid, comparable.title, cmp.comparable_id, cmp.comparable_type, cmp.score_n
FROM comparisons cmp
LEFT OUTER JOIN appraisals a ON cmp.appraisal_id = a.id AND a.member_id = 30
LEFT OUTER JOIN alternatives comparable ON comparable.id = cmp.comparable_id
LEFT OUTER JOIN criteria c ON c.id = a.criterion_id
WHERE c.article_id = 28 AND cmp.comparable_type = 'Alternative'