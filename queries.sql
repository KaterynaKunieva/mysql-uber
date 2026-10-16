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

-- ROUTE WITH BRIDGES
set @start_id = 1;
set @finish_id = 7;
set @require_bridge = true;
set @recursion_depth = 100;

with recursive route_cte as (
    -- initial case
    select @start_id                                       as current_intersection,
           cast(0.00 as decimal(6, 2))                     as total_distance_km,
           cast(concat(',', @start_id, ',') as char(1000)) as visited_intersections,
           cast('' as char(3000))                          as route_details,
           0                                               as recursion_depth,
           0                                               as has_bridge

    union all

    -- recursive case
    select ns.next_intersection                                            as current_intersection,
           r.total_distance_km + ns.distance_km                            as total_distance_km,
           concat(r.visited_intersections, ns.next_intersection, ',')      as visited_intersections,
           concat(r.route_details,
                  if(r.route_details = '', '', ' -> '),
                  '(', r.current_intersection, ',', ns.next_intersection, ')_', ns.street_segment_type, '_',
                  ns.distance_km, 'km')                                    as path_details,
           r.recursion_depth + 1                                           as recursion_depth,
           if(r.has_bridge = 1 or ns.street_segment_type = 'bridge', 1, 0) as has_bridge
    from route_cte r
             -- select all next segments that start from current_intersection
             cross join lateral (select ss.*,
                                        if(ss.intersection_id_start = r.current_intersection, ss.intersection_id_end,
                                           ss.intersection_id_start) as next_intersection
                                 from street_segment ss
                                 where ss.drivable = true
                                   and (ss.intersection_id_start = r.current_intersection or
                                        ss.intersection_id_end = r.current_intersection)) ns
    where r.current_intersection <> @finish_id
      and locate(concat(',', ns.next_intersection, ','), r.visited_intersections) = 0
      and r.recursion_depth < @recursion_depth)

select total_distance_km, route_details
from route_cte
where current_intersection = @finish_id
  and (not @require_bridge or has_bridge = 1)
order by total_distance_km;
