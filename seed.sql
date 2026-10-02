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


insert ignore into `passenger` 
    (`first_name`, `last_name`, `email`, `phone`, `birth_date`, `home_house_id`)
values 
    ('Олена', 'Коваль', 'olena@example.com', '+380971234567', '2000-05-15', 1), 
    ('Максим', 'Бойко', 'maksym@example.com', '+380639876543', '1995-12-01', 4),
    ('Ірина', 'Петренко', 'olena@example.com', '+380501112233', '1998-03-20', NULL),
	('Андрій', 'Сидоренко', 'andriy@example.com', '+380971234567', '1992-07-10', NULL);
