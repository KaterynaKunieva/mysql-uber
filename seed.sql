use `uber`;

insert ignore into `street` (`id`, `name`, `drivable`) values 
    (1, 'тараса шевченка', default), 
    (2, 'лесі українки', true), 
    (3, 'богдана хмельницького', false);

insert ignore into `house` (`id`, `number`, `street_id`) values
    (1, '1a', 1),
    (2, '1b', 1), 
    (3, '1c', 1), 
    (10, '1d', 1), 
    (4, '2a', 2), 
    (5, '2b', 2), 
    (6, '2c', 2), 
    (7, '2d', 2), 
    (8, '3a', 3), 
    (9, '3b', 3);

insert ignore into `user` (`id`, `first_name`, `last_name`, `email`, `phone`) values
    (1, 'олена', 'коваль', 'olena@example.com', '+380971234567'),
    (2, 'максим', 'бойко', 'maksym@example.com', '+380639876543'),
    (3, 'ірина', 'петренко', 'iryna@example.com', '+380501112233'),
    (4, 'андрій', 'сидоренко', 'andriy@example.com', '+380979998877'),
    (5, 'дмитро', 'шевченко', 'dmytro@example.com', '+380935554433');

insert ignore into `passenger` (`user_id`, `home_house_id`, `rating`) values
    (1, 1, 4.90),
    (2, 4, 5.00),
    (3, null, 4.75);

insert ignore into `driver` (`user_id`, `license_number`, `rating`) values
    (4, 'ab123456', 4.85);

insert ignore into `operator` (`user_id`) values
    (5);

insert ignore into `trip` 
    (`id`, `passenger_id`, `driver_id`, `pickup_house_id`, `destination_house_id`, `status`, `distance_km`, `price`, `started_at`, `completed_at`)
values
    (1, 1, 4, 1, 4, 'completed', 5.20, 150.00, '2026-10-01 10:00:00', '2026-10-01 10:15:00'),
    (2, 2, 4, 5, 2, 'completed', 3.10, 110.00, '2026-10-02 14:20:00', '2026-10-02 14:30:00'),
    (3, 3, null, 2, 8, 'created', null, null, null, null);

insert ignore into `review` (`trip_id`, `author_id`, `target_id`, `score`, `comment`) values
    (1, 1, 4, 5, 'чудовий водій, машини чиста!'),
    (1, 4, 1, 5, 'ввічлива пасажирка.');
