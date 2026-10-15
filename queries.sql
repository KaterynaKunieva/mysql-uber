use `uber`;

select concat(s.`name`, ', ', h.`number`) as 'available_adresses'
from `house` h
         join `street_segment` ss on h.`street_segment_id` = ss.`id`
         join `street` s on ss.`street_id` = s.`id`;

select s.`id`, s.`name` as 'street', count(h.`id`) as 'houses'
from `house` h
         join `street_segment` ss on h.`street_segment_id` = ss.`id`
         join `street` s on ss.`street_id` = s.`id`
group by s.`id`, s.`name`
order by `houses` desc;

explain
select p.user_id as id, concat(u.first_name, ' ', u.last_name) as 'passenger_name'
from `passenger` p
         join `user` u on p.`user_id` = u.`id`
where u.`last_name` = 'коваль'
  and u.`first_name` = 'олена';

explain
select p.user_id as id, concat(u.first_name, ' ', u.last_name) as 'passenger_name'
from `passenger` p
         join `user` u on p.`user_id` = u.`id`
where u.`last_name` = 'коваль';

-- STREET WITH THE BIGGEST AMOUNT OF HOUSES 
select s.`id`, s.`name`, count(h.`id`) as `house_amount`
from `street` s
         join `street_segment` ss on ss.`street_id` = s.`id`
         join `house` h on h.`street_segment_id` = ss.`id`
group by s.`id`, s.`name`
order by `house_amount` desc
limit 1;

-- ALL STREETS WITH THE BIGGEST AMOUNT OF HOUSES
select s.`id`, s.`name`, count(h.`id`) as `house_amount`
from `street` s
         join `street_segment` ss on ss.`street_id` = s.`id`
         join `house` h on h.`street_segment_id` = ss.`id`
group by s.`id`, s.`name`
having `house_amount` = (select count(h_sub.`id`)
                         from `house` h_sub
                                  join `street_segment` ss_sub on h_sub.`street_segment_id` = ss_sub.`id`
                         group by ss_sub.`street_id`
                         order by count(h_sub.`id`) desc
                         limit 1);
