create database if not exists `uber` 
	character set utf8mb4
    collate utf8mb4_unicode_ci;

use `uber`;

create table if not exists `street`(
	`id` INT unsigned auto_increment primary key,
	`name` VARCHAR(255) not null unique,
	`drivable` BOOLEAN not null default true
);

create table if not exists `house`(
	`id` INT unsigned auto_increment primary key,
	`number` VARCHAR(50) not null,
	`street_id` INT unsigned not null,
	constraint `fk_house_street` 
		foreign key (`street_id`) 
		references `street` (`id`)
		on delete cascade 
		on update cascade,
	constraint `uk_house_street_number`
        unique (`street_id`, `number`)
);

create table if not exists `passenger` (
    `id` INT unsigned auto_increment primary key,
    `first_name` VARCHAR(100) not null,
    `last_name` VARCHAR(100) not null,
    `email` VARCHAR(255) not null,
    `phone` VARCHAR(20) not null,
    `birth_date` DATE null,
    `home_house_id` INT unsigned null,
    `avatar_url` VARCHAR(512) null,
    `created_at` DATETIME not null default CURRENT_TIMESTAMP,
 
    constraint `uk_passenger_email` unique (`email`),
    constraint `uk_passenger_phone` unique (`phone`),

    constraint `fk_passenger_home_house` 
        foreign key (`home_house_id`) 
        references `house` (`id`)
        on delete set null 
        on update cascade,

    constraint `chk_passenger_birth_date` 
    	check (`birth_date` is null or (`birth_date` >= '1900-01-01' and `birth_date` <= current_date()))
);

create index `idx_passenger_last_first_name` 
    on `passenger` (`last_name`, `first_name`);

create table if not exists `user` (
    `id` int unsigned auto_increment primary key,
    `first_name` varchar(100) not null,
    `last_name` varchar(100) not null,
    `email` varchar(255) not null,
    `phone` varchar(20) not null,
    `password_hash` varchar(255) null,
    `is_active` boolean not null default true,
    `created_at` datetime not null default current_timestamp,

    constraint `uk_user_email` unique (`email`),
    constraint `uk_user_phone` unique (`phone`)
);

-- start migrate passenger to user
insert into `user` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`)
select `id`, `first_name`, `last_name`, `email`, `phone`, `created_at`
from `passenger`
on duplicate key update `id` = `user`.`id`;

drop index `idx_passenger_last_first_name` on `passenger`;

alter table `passenger` drop foreign key `fk_passenger_home_house`;
alter table `passenger` drop index `uk_passenger_email`;
alter table `passenger` drop index `uk_passenger_phone`;
alter table `passenger` drop constraint `chk_passenger_birth_date`;

alter table `passenger`
    drop column `first_name`,
    drop column `last_name`,
    drop column `email`,
    drop column `phone`,
    drop column `birth_date`,
    drop column `avatar_url`,
    drop column `created_at`,
    change column `id` `user_id` int unsigned not null,
    drop primary key,
    add primary key (`user_id`),
    add column `rating` decimal(3, 2) not null default 5.00;

alter table `passenger`
    add constraint `fk_passenger_user` 
        foreign key (`user_id`) references `user` (`id`)
        on delete cascade on update cascade,
    add constraint `fk_passenger_home_house` 
        foreign key (`home_house_id`) references `house` (`id`)
        on delete set null on update cascade,
    add constraint `chk_passenger_rating` 
        check (`rating` >= 1.00 and `rating` <= 5.00);
-- end migrate passenger to user

create table if not exists `driver` (
    `user_id` int unsigned primary key,
    `license_number` varchar(50) not null,
    `rating` decimal(3, 2) not null default 5.00,

    constraint `uk_driver_license` unique (`license_number`),

    constraint `fk_driver_user` 
        foreign key (`user_id`) references `user` (`id`)
        on delete cascade on update cascade,

    constraint `chk_driver_rating` 
        check (`rating` >= 1.00 and `rating` <= 5.00)
);

create table if not exists `operator` (
    `user_id` int unsigned primary key,

    constraint `fk_operator_user` 
        foreign key (`user_id`) references `user` (`id`)
        on delete cascade on update cascade
);

create table if not exists `trip` (
    `id` int unsigned auto_increment primary key,
    `passenger_id` int unsigned not null,
    `driver_id` int unsigned null,
    
    `pickup_house_id` int unsigned not null,
    `destination_house_id` int unsigned not null,
    
    `status` enum('created', 'accepted', 'in_progress', 'completed', 'cancelled') not null default 'created',
    `distance_km` decimal(6, 2) null,
    `price` decimal(8, 2) null,
    
    `started_at` datetime null,
    `completed_at` datetime null,
    `created_at` datetime not null default current_timestamp,

    constraint `fk_trip_passenger` 
        foreign key (`passenger_id`) references `passenger` (`user_id`)
        on delete restrict on update cascade,

    constraint `fk_trip_driver` 
        foreign key (`driver_id`) references `driver` (`user_id`)
        on delete restrict on update cascade,

    constraint `fk_trip_pickup_house` 
        foreign key (`pickup_house_id`) references `house` (`id`)
        on delete restrict on update cascade,

    constraint `fk_trip_dest_house` 
        foreign key (`destination_house_id`) references `house` (`id`)
        on delete restrict on update cascade
);

create index `idx_trip_passenger_created` 
    on `trip` (`passenger_id`, `created_at` desc);

create index `idx_trip_driver_created` 
    on `trip` (`driver_id`, `created_at` desc);

create index `idx_trip_status_created` 
    on `trip` (`status`, `created_at` desc);

create table if not exists `review` (
    `id` int unsigned auto_increment primary key,
    `trip_id` int unsigned not null,
    `author_id` int unsigned not null, 
    `target_id` int unsigned not null, 
    `score` tinyint unsigned not null,
    `comment` text null,
    `created_at` datetime not null default current_timestamp,

    constraint `uk_review_trip_author` unique (`trip_id`, `author_id`),
    constraint `chk_review_score` check (`score` >= 1 and `score` <= 5),

    constraint `fk_review_trip` 
        foreign key (`trip_id`) references `trip` (`id`)
        on delete cascade on update cascade,

    constraint `fk_review_author` 
        foreign key (`author_id`) references `user` (`id`)
        on delete cascade on update cascade,

    constraint `fk_review_target` 
        foreign key (`target_id`) references `user` (`id`)
        on delete cascade on update cascade
);

create index `idx_review_target_created` 
    on `review` (`target_id`, `created_at` desc);
