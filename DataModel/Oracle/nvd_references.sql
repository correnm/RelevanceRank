DROP table RESEARCH.nvd_references;

CREATE TABLE RESEARCH.NVD_REFERENCES
(
CVE_ID 					VARCHAR2(20 CHAR),
URL						VARCHAR2(500 CHAR),
NAME					VARCHAR2(500 CHAR),
REFSOURCE				VARCHAR2(100 CHAR),
TAG						VARCHAR2(50 CHAR)
);
