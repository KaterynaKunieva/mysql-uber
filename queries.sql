use `uber`;

select concat(s.`name`, ', ',  h.`number`) as 'available_adresses' 
from `house` h
	join `street` s on h.`street_id` = s.`id`
where s.`drivable` = true

select s.`id`, s.`name` as 'street', count(h.`id`) as 'houses'
from `house` h
	join `street` s on h.`street_id` = s.`id`
group by h.`street_id` 
order by `houses` desc;