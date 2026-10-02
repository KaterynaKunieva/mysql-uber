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

