DROP table RESEARCH.cwe;

CREATE TABLE RESEARCH.CWE
(
CWE_ID 						VARCHAR2(20 CHAR),
NAME						VARCHAR2(200 CHAR),
DESCRIPTION					VARCHAR2(4000 CHAR),
LIKELIHOOD_OF_EXPLOIT		VARCHAR2(100 CHAR)
);

-- standardize CWE naming.
UPDATE research.cwe
set cwe_id = 'CWE-' || cwe_id;


COMMENT ON TABLE RESEARCH.cwe is
'The Common Weakness Enumeration (CWE) is a category system for software weaknesses and vulnerabilities.';

-- Primary Key
ALTER TABLE RESEARCH.cwe 
ADD CONSTRAINT cwe_pk  PRIMARY KEY (cwe_id); 

-- these values are not actually in the CWE but are referenced in the NVD. Records are needed for the table's foreign key
insert into research.cwe
(cwe_id, name, description)
values
('NVD-CWE-noinfo', 'Insufficient information','added manually for consistency);

insert into research.cwe
(cwe_id, name, description)
values
('NVD-CWE-Other', 'Other', 'added manually for consistency');
 

