select * from (select *,
case when latest_date>requiredDate then 1 else 0 end as lateness_flag 
from (select *, 
date_add(shippeddate,interval 3 day) as latest_date
from orders) sb) sb2
where lateness_flag =1
