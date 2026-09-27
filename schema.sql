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