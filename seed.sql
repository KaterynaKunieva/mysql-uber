use `uber`;

-- 1. Streets
insert ignore into `street` (`id`, `name`, `drivable`) values 
    (1, 'центральна', true), 
    (2, 'набережна', true), 
    (3, 'садова', true),
    (4, 'київська', true);

-- 2. Intersections (nodes representing city intersections on Left and Right banks)
insert ignore into `intersection` (`id`) values 
    (1), (2), (3), (4), (5), (6), (7);

-- 3. Street Segments (edges connecting intersections with distance_km)
insert ignore into `street_segment` (`id`, `street_id`, `street_segment_type`, `intersection_id_start`, `intersection_id_end`, `distance_km`) values
    -- Left bank segments
    (1, 1, 'normal', 1, 2, 1.50),
    (2, 1, 'normal', 2, 3, 2.00),
    (3, 3, 'normal', 1, 3, 3.20),
    
    -- Bridges crossing the river (with different lengths to test route optimization/choice)
    (10, 1, 'bridge', 2, 4, 1.20), -- Bridge 1 (shorter)
    (11, 2, 'bridge', 3, 6, 2.80), -- Bridge 2 (longer)
    
    -- Right bank segments
    (4, 2, 'normal', 4, 5, 1.10),
    (5, 2, 'normal', 5, 6, 1.80),
    (6, 4, 'normal', 6, 7, 2.50),
    (7, 4, 'normal', 4, 7, 3.00);

-- 4. Houses (linked to street segments)
insert ignore into `house` (`id`, `number`, `street_segment_id`) values
    (1, '1a', 1),
    (2, '1b', 1), 
    (3, '2a', 4), 
    (4, '2b', 4), 
    (5, '3a', 5), 
    (6, '4a', 6);

-- 5. Users
insert ignore into `user` (`id`, `first_name`, `last_name`, `email`, `phone`) values
    (1, 'олена', 'коваль', 'olena@example.com', '+380971234567'),
    (2, 'максим', 'бойко', 'maksym@example.com', '+380639876543'),
    (3, 'ірина', 'петренко', 'iryna@example.com', '+380501112233'),
    (4, 'андрій', 'сидоренко', 'andriy@example.com', '+380979998877'),
    (5, 'дмитро', 'шевченко', 'dmytro@example.com', '+380935554433');

-- 6. Passengers
insert ignore into `passenger` (`user_id`, `home_house_id`, `rating`) values
    (1, 1, 4.90),
    (2, 3, 5.00),
    (3, null, 4.75);

-- 7. Drivers
insert ignore into `driver` (`user_id`, `license_number`, `rating`) values
    (4, 'ab123456', 4.85);

-- 8. Operators
insert ignore into `operator` (`user_id`) values
    (5);

-- 9. Trips
insert ignore into `trip` 
    (`id`, `passenger_id`, `driver_id`, `pickup_house_id`, `destination_house_id`, `status`, `distance_km`, `price`, `started_at`, `completed_at`)
values
    (1, 1, 4, 1, 3, 'completed', 5.20, 150.00, '2026-10-01 10:00:00', '2026-10-01 10:15:00'),
    (2, 2, 4, 4, 2, 'completed', 3.10, 110.00, '2026-10-02 14:20:00', '2026-10-02 14:30:00'),
    (3, 3, null, 1, 5, 'created', null, null, null, null);

-- 10. Reviews
insert ignore into `review` (`trip_id`, `author_id`, `target_id`, `score`, `comment`) values
    (1, 1, 4, 5, 'чудовий водій, машини чиста!'),
    (1, 4, 1, 5, 'ввічлива пасажирка.');
