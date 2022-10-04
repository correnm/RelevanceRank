SELECT org,  
to_char(week_start, 'MON-YYYY') AS month_yy,
count(*) AS vulns
FROM relevance_rank_final
WHERE to_char(week_start,'MON') = 'DEC'
GROUP BY org, to_char(week_start, 'MON-YYYY')
ORDER BY 1, 2;

/*
 * p_org_id 				IN VARCHAR2,
	p_group_country			IN VARCHAR2 DEFAULT 'Russia',
	p_risk_appetite			IN NUMBER   DEFAULT 0.876,
	p_cve_year				IN NUMBER	DEFAULT 2019,
	p_cve_end_year			IN NUMBER	DEFAULT 2021,
	p_delete_old_entries	IN VARCHAR2 DEFAULT 'N',
	p_scenario				IN NUMBER   DEFAULT 1,
	p_likelihood_of_attack	IN VARCHAR2 DEFAULT 'High',
	p_severity				IN VARCHAR2 DEFAULT 'High',
	p_skill_level			IN VARCHAR2 DEFAULT 'High'
 */

-- calculate relevance for this sector
CALL RESEARCH.calcRelevanceScore('', 'Iran', 0.876, 2019, 2021,'Y', 2, 'High', 'High','High');

-- check feature vector
SELECT
org,
to_char(week_start, 'MON-YYYY') 	AS month_year,
count(cve_id) 						AS vulns,
sum(software) 						AS software,
SUM(remote_exploitable) 			AS remote_exploitable,
SUM(known_exploit) 					AS known_exploit,
sum(risk_appetite_met) 				AS risk_appetite_met,
sum(known_threat) 					AS known_threat,
sum(known_threat_country) 			AS known_threat_country,
sum(sector_threat) 					AS sector_threat,
sum(sector_threat_country) 			AS sector_threat_country,
min(cvss_base_score) 				AS cvss_base_score_min,
max(cvss_base_score) 				AS cvss_base_score_max,
min(rel_score) 						AS rel_score_min,
max(rel_score) 						AS rel_score_max
FROM relevance_rank_final
--WHERE to_char(week_start,'MON') = 'JAN'
GROUP BY org, to_char(week_start, 'MON-YYYY')
ORDER BY 2,1 ;


-- calculate NDCG by week
SELECT
d.org,
to_char(d.week_start, 'dd-MON-yyyy') AS patch_tuesday,
--d.cve_id, d.cvss_base_score,
--i.cve_id, i.cvss_base_score,
( 
SELECT count(cve_id)
FROM relevance_rank_final f
WHERE d.org = f.org
AND d.week_start = f.week_start
) AS vulns_this_week,
max(e.rel_score) AS rel_max,
max(i.ideal_score) AS ideal_max,
--min(d.rel_score) AS rel_min,
--max(d.rel_score) AS rel_max,
--min(d.cvss_base_score) AS cvss_min,
--max(d.cvss_base_score) AS cvss_max,
sum(d.d_cost) AS cvss_cost,
sum(e.e_cost) AS my_cost,
sum(i.i_cost) AS ideal_cost,
max(d.known_exploit) AS exploited,
-- avoid divide by zero
trunc(SUM(d.dcg)/sum(DECODE(i.idcg, 0, NULL, i.idcg)), 3) AS cvss_ndcg,
trunc(SUM(e.dcg)/sum(DECODE(i.idcg, 0, NULL, i.idcg)), 3) AS my_ndcg
--SELECT *
FROM
(
SELECT 
org,
week_start,
cve_id,
cvss_base_rank,
cvss_base_score,
rel_rank,
rel_score,
ideal_rank,
ideal_score,
cost AS d_cost,
software,
remote_exploitable,
known_exploit,
risk_appetite_met,
known_threat,
known_threat_country,
sector_threat,
sector_threat_country,
trunc(rel_score/log(2, cvss_base_rank+1), 3) AS DCG
FROM relevance_rank_final
ORDER BY org, week_start, cvss_base_rank ASC
) D,
(
SELECT 
org,
week_start,
cve_id,
cvss_base_rank,
cvss_base_score,
rel_rank,
rel_score,
ideal_rank,
ideal_score,
cost AS e_cost,
software,
remote_exploitable,
known_exploit,
risk_appetite_met,
known_threat,
known_threat_country,
sector_threat,
sector_threat_country,
trunc(rel_score/log(2, rel_rank+1), 3) AS DCG
FROM relevance_rank_final
ORDER BY org, week_start, rel_rank ASC
) e,
(
SELECT 
org,
week_start,
cve_id,
cvss_base_rank,
cvss_base_score,
rel_rank,
rel_score,
ideal_rank,
ideal_score,
cost AS i_cost,
software,
remote_exploitable,
known_exploit,
risk_appetite_met,
known_threat,
known_threat_country,
sector_threat,
sector_threat_country,
trunc(ideal_score/log(2, ideal_rank+1),3) AS iDCG
FROM relevance_rank_final
ORDER BY org, week_start, ideal_rank ASc
) I
WHERE d.org = i.org AND e.org = i.org
AND d.week_start = i.week_start AND e.week_start = i.week_start
--AND d.cve_id = i.cve_id
AND d.cvss_base_rank = i.ideal_rank AND e.rel_rank = i.ideal_rank
-- NDCG@XX
AND d.cvss_base_rank <=100
--AND d.org='WM'
GROUP BY d.org, d.week_start 
HAVING count(d.cve_id) >=100
--d.cvss_base_rank--, d.cve_id, i.cve_id, d.cvss_base_score, i.cvss_base_score
ORDER BY d.org, d.week_start ASC

--- calculate NDCG by CVE_ID
SELECT
d.org,
to_char(d.week_start, 'dd-MON-yyyy') AS patch_tuesday,
( 
SELECT count(cve_id)
FROM relevance_rank_final f
WHERE d.org = f.org
AND d.week_start = f.week_start
) AS vulns_this_week,
d.cve_id, 
d.cvss_base_score,
d.cvss_base_rank,
e.rel_rank,
e.rel_score,
d.d_cost AS cvss_cost,
e.e_cost AS rel_cost,
d.known_exploit AS exploited,
d.dcg AS cvss_dcg,
e.dcg AS rel_dcg,
(SELECT date_added
FROM cisa_exploit_catalog c
WHERE c.cve_id = d.cve_id) AS CISA_ADD_DATE
--SELECT *
FROM
(
SELECT 
org,
week_start,
cve_id,
cvss_base_rank,
cvss_base_score,
rel_rank,
rel_score,
ideal_rank,
ideal_score,
cost AS d_cost,
software,
remote_exploitable,
known_exploit,
risk_appetite_met,
known_threat,
known_threat_country,
sector_threat,
sector_threat_country,
trunc(rel_score/log(2, cvss_base_rank+1), 3) AS DCG
FROM relevance_rank_final
ORDER BY org, week_start, cvss_base_rank ASC
) D,
(
SELECT 
org,
week_start,
cve_id,
cvss_base_rank,
cvss_base_score,
rel_rank,
rel_score,
ideal_rank,
ideal_score,
cost AS e_cost,
software,
remote_exploitable,
known_exploit,
risk_appetite_met,
known_threat,
known_threat_country,
sector_threat,
sector_threat_country,
trunc(rel_score/log(2, rel_rank+1), 3) AS DCG
FROM relevance_rank_final
ORDER BY org, week_start, rel_rank ASC
) e,
(
SELECT 
org,
week_start,
cve_id,
cvss_base_rank,
cvss_base_score,
rel_rank,
rel_score,
ideal_rank,
ideal_score,
cost AS i_cost,
software,
remote_exploitable,
known_exploit,
risk_appetite_met,
known_threat,
known_threat_country,
sector_threat,
sector_threat_country,
trunc(ideal_score/log(2, ideal_rank+1),3) AS iDCG
FROM relevance_rank_final
ORDER BY org, week_start, ideal_rank ASc
) I
WHERE d.org = i.org AND e.org = i.org
AND d.week_start = i.week_start AND e.week_start = i.week_start
AND d.cve_id = i.cve_id AND e.cve_id = i.cve_id
AND d.known_exploit=1 AND d.cvss_base_rank < e.rel_rank
ORDER BY d.org, d.week_start, d.cvss_base_rank ASC
