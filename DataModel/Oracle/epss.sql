DROP table RESEARCH.epss

CREATE TABLE RESEARCH.epss
(
CVE_ID 					VARCHAR2(100 CHAR),
epss_score				NUMBER(10,8),
percentile				NUMBER(10,8)
);

COMMENT on table research.epss is 'EPSS provides a fundamentally new capability for efficient, data-driven vulnerability management. It is an open, data-driven effort that uses current threat information from CVE and real-world exploit data. The EPSS model produces a probability score between 0 and 1 (0 and 100%), where the higher the score, the greater the probability that a vulnerability will be exploited.';


-- Primary Key
ALTER TABLE RESEARCH.epss
ADD CONSTRAINT epss_pk  PRIMARY KEY (cve_id);  

-- Foreign key
ALTER TABLE RESEARCH.epss
ADD CONSTRAINT epss_fk1
  FOREIGN KEY (cve_id)
  REFERENCES nvd_cve (cve_id);