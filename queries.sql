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

explain 
	select id, concat(p.first_name, ' ', p.last_name) as 'passenger_name'
from `passenger` p
where `last_name` = 'Коваль' and `first_name` = 'Олена';

explain 
	select id, concat(p.first_name, ' ', p.last_name) as 'passenger_name'
from `passenger` p
where `last_name` = 'Коваль';

-- STREET WITH THE BIGGEST AMOUNT OF HOUSES
select s.`id`, s.`name`, count(h.`id`) as `house_amount`
from `street` s
join `house` h on h.`street_id` = s.`id`
group by s.`id`, s.`name`
having `house_amount` = (
    select count(`id`)
    from `house`
    group by `street_id`
    order by count(`id`) desc
    limit 1
);