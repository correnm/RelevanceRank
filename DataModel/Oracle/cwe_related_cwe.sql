DROP table RESEARCH.cwe_related_cwe;

CREATE TABLE RESEARCH.CWE_RELATED_CWE
(
CWE_ID 						VARCHAR2(20 CHAR),
NATURE						VARCHAR2(50 CHAR),
RELATED_CWE_ID				VARCHAR2(20 CHAR)
);

https://www.linkedin.com/posts/projectblueusn_cybersecurity-rmf-activity-6896167075006574592-E_Xm

// insert from load table 0 to 7
INSERT into research.cwe_related_cwe
SELECT cwe_id, 
nature7, 
CWE_ID7 
FROM CWE_RELATED_CWE_LOAD crcl;

DELETE FROM CWE_RELATED_CWE crc WHERE RELATED_CWE_ID  IS null;

-- standardize CWE naming.
UPDATE research.cwe_related_cwe
set cwe_id = 'CWE-' || cwe_id;

UPDATE research.cwe_related_cwe
set related_cwe_id = 'CWE-' || related_cwe_id;

