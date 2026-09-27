use `uber`;

insert ignore into `street`(`name`, `drivable`) VALUES 
	('Тараса Шевченка', default), 
	('Лесі Українки', true), 
	('Богдана Хмельницького', false);


insert ignore into `house`(`number`, `street_id`) VALUES
	('1a', 1),
	('1b', 1), 
	('1c', 1), 
	('2a', 2), 
	('2b', 2), 
	('2c', 2), 
	('2d', 2), 
	('3a', 3), 
	('3b', 3);