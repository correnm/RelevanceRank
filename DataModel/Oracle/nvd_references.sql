DROP table RESEARCH.nvd_references;

CREATE TABLE RESEARCH.NVD_REFERENCES
(
CVE_ID 					VARCHAR2(20 CHAR),
URL						VARCHAR2(500 CHAR),
NAME					VARCHAR2(500 CHAR),
REFSOURCE				VARCHAR2(100 CHAR),
TAG						VARCHAR2(50 CHAR)
);

COMMENT ON TABLE RESEARCH.nvd_references is
'Links to other web sites because they may have information that would be of interest for this CVE-ID.';

ALTER TABLE RESEARCH.nvd_references
ADD CONSTRAINT nvd_references_pk  PRIMARY KEY (cve_id, url, name, tag);  

-- Foreign key
ALTER TABLE RESEARCH.nvd_references
ADD CONSTRAINT nvd_references_fk
  FOREIGN KEY (cve_id)
  REFERENCES nvd_cve (cve_id);