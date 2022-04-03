DROP table RESEARCH.nvd_cve;

CREATE TABLE RESEARCH.NVD_CVE 
(
CVE_YEAR 				NUMBER(4), 
CVE_ID 					VARCHAR2(20 CHAR),
ASSIGNER				VARCHAR2(100 char),
CVE_DESCRIPTION 		VARCHAR2(4000 CHAR), 
CVSS_BASE_SCORE 		NUMBER(3,1), 
CVSS_VECTOR 			VARCHAR2(100 CHAR), 
CVSS_TEMPORAL_SCORE 	NUMBER(3,1), 
CVSS_TEMPORAL_VECTOR 	VARCHAR2(100 CHAR), 
EXPLOITABILITY 			NUMBER(3,1), 
IMPACT 					NUMBER(3,1), 
attackVector			VARCHAR2(20 CHAR), 
attackComplexity		VARCHAR2(20 CHAR), 
privilegesRequired		VARCHAR2(20 CHAR), 
userInteraction			VARCHAR2(20 CHAR), 
scope					VARCHAR2(20 CHAR),
confidentialityImpact   VARCHAR2(20 CHAR), 
integrityImpact			VARCHAR2(20 CHAR), 
availabilityImpact		VARCHAR2(20 CHAR), 
PUBLISHED_DATE 			DATE,
MODIFIED_DATE 			DATE,
TIER 					NUMBER(2),
AGE_IN_DAYS 			NUMBER,
SEVERITY 				VARCHAR2(20 CHAR)
);

COMMENT ON TABLE RESEARCH.nvd_cve is
'The NVD is the U.S. government repository of standards based vulnerability management data represented using the Security Content Automation Protocol (SCAP). This data enables automation of vulnerability management, security measurement, and compliance.';

ALTER TABLE RESEARCH.nvd_cve 
ADD CONSTRAINT nvd_cve_pk  PRIMARY KEY (cve_id);  

// age the vulnerabilities as the last day in 2021, when collected,  based on the publication date
UPDATE NVD_CVE 
SET age_in_days = trunc(to_date('01-dec-2021')-published_date);
