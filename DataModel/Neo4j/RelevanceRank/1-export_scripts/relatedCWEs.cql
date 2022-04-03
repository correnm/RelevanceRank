// Use Excel functions to:
// remove duplicates 
// remove CVEs with no CWE
// replace { with null
// replace } with null
// replace ' with null
// split related_cwes into two columns cwe_id, cwe_name using the : delimiter with Excel formula (left, right)

select cve_id,
related_cwes
from common_usages.common_vulnerabilities
where year_modified =2021;