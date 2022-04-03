// Use Excel functions to:
// remove duplicates 
// replace { with null
// replace } with null
// replace ' with null
// split related_cwes into two columns cwe_id, cwe_name using the : delimiter with Excel formula (left, right)

select cpe_id,
title,
part,
vendor,
product,
version,
from common_usages.common_platforms;