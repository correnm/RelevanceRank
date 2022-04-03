select cve_id,
cve_description,
cvss_base_score,
cvss_vector,
cvss_temporal_score,
cvss_temporal_vector,
exploitability,
impact,
severity,
patch_tag,
modified_date,
year_modified,
cpe_affected,
part,
vendor,
product,
version
from common_usages.common_vulnerabilities
where year_modified=2021;