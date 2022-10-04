DROP TABLE research.relevance_rank;

CREATE TABLE research.relevance_rank
(
organization_short_name		VARCHAR2(10) 		NOT NULL,
scenario					VARCHAR2(100) 		NOT NULL,
apt_country					VARCHAR2(100),
risk_appetite				NUMBER(3,2),
cve_year					NUMBER(4)			NOT NULL,
p_likelihood				VARCHAR2(25),
p_severity					VARCHAR2(25),
p_skill_level				VARCHAR2(25),
week_start					DATE,
CVE_ID 						VARCHAR2(20 CHAR)	NOT NULL, 
CVSS_BASE_SCORE				NUMBER(3,1)			NOT NULL,
cvss_temporal_score			NUMBER(3,1),
cvss_base_rank				NUMBER(3),
rel_score					NUMBER(3), 
rel_rank					NUMBER(3),
ideal_score					NUMBER(3), 
ideal_rank					NUMBER(3),
cost						NUMBER(5,2),
software					NUMBER(1),
remote_exploitable			NUMBER(1),
known_exploit				NUMBER(1),
risk_appetite_met			NUMBER(1),
known_threat				NUMBER(1),
known_threat_country		NUMBER(1),
sector_threat				NUMBER(1),
sector_threat_country		NUMBER(1),
likelihood					NUMBER(1),
severity					NUMBER(1),
skill_level					NUMBER(1)
);

COMMENT ON TABLE RESEARCH.relevance_rank is
'relevance scoring used for ranking';

CREATE OR REPLACE VIEW relevance_rank_final AS 
SELECT organization_short_name AS org, 
scenario,
apt_country,
risk_appetite,
cve_year, 
p_likelihood,
p_severity,
p_skill_level,
week_start, 
cve_id,
cvss_base_score,
cvss_temporal_score,
RANK() OVER (PARTITION BY organization_short_name, week_start ORDER BY cvss_base_score DESC, cve_id ASC) AS cvss_base_rank,
rel_score,
RANK() OVER (PARTITION BY organization_short_name, week_start ORDER BY  rel_score DESC, cve_id ASC) AS rel_rank,
ideal_score,
RANK() OVER (PARTITION BY organization_short_name, week_start ORDER BY  ideal_score DESC, cve_id ASC) AS ideal_rank,
cost,
software,
remote_exploitable,
known_exploit,
risk_appetite_met,
known_threat,
known_threat_country,
sector_threat,
sector_threat_country,
likelihood,
severity,
skill_level
FROM relevance_rank
ORDER BY organization_short_name, week_start;