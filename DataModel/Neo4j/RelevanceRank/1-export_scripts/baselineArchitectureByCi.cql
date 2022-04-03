// Use Excel functions to:
// remove '[/' and ']' from ip_address columns
// MATCH baseline architecture to commonPlatforms
//	replace 'Hewlett Packard' with 'hp'
//	replace 'Dell Inc.' with 'dell'

//mission id : _19_0_4_1dc604bb_1626728163060_684771_197 : Prepare Plans 
//mission id : _19_0_4_1dc604bb_1626728152332_637904_196 : Collect target information
select platform_name,
system_name,
subsystem_name,
missions['_19_0_4_1dc604bb_1626728152332_637904_196']  as mission,
host_name, 
ip_address, 
vendor,
installed_software_list 
from iris.baseline_architecture_by_ci;