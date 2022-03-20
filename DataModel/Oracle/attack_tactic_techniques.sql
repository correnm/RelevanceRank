DROP table RESEARCH.attack_tactic_techniques;

CREATE TABLE research.attack_tactic_techniques
AS
select  
TECHNIQUE_ID,
tactic_id,
IS_SUB_TECHNIQUE 
from ATTACK_ENTERPRISE_TECHNIQUES aet,
attack_enterprise_tactics AT
WHERE instr(tactics, tactic_name) > 0
ORDER BY 1;

COMMENT ON TABLE RESEARCH.attack_tactic_techniques is
'Tactics mapped to associated techniques and subtechniques';

-- Primary Key
ALTER TABLE RESEARCH.attack_tactic_techniques  
ADD CONSTRAINT attack_tactic_tech_pk  PRIMARY KEY (technique_id, tactic_id);  

-- Foreign key
ALTER TABLE RESEARCH.attack_tactic_techniques  
ADD CONSTRAINT attack_tactic_tech_fk1
  FOREIGN KEY (technique_id)
  REFERENCES attack_enterprise_techniques (technique_id);
  
ALTER TABLE RESEARCH.attack_tactic_techniques  
ADD CONSTRAINT attack_tactic_tech_fk2
  FOREIGN KEY (tactic_id)
  REFERENCES attack_enterprise_tactics (tactic_id);

