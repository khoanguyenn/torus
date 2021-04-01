CREATE DATABASE IF NOT EXISTS torus;
USE torus;

CREATE TABLE `user` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `email` varchar(320) UNIQUE NOT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(255) NOT NULL,
  `role` ENUM ('admin', 'tutee', 'tutor') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `user_info` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` integer UNIQUE NOT NULL,
  `name` varchar(255) NOT NULL,
  `gender` varchar(1) DEFAULT "m",
  `phone` varchar(15),
  `grade` int,
  `picture_link` varchar(200),
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `user_score` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` integer NOT NULL,
  `score` double NOT NULL,
  `subject_id` integer NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `class` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `tutor_id` integer NOT NULL,
  `subject_id` integer NOT NULL,
  `description` varchar(500),
  `picture_link` varchar(200),
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `class_schedule` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `class_id` integer NOT NULL,
  `date_occurring` date NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `slot` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `class_schedule_id` int NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `number_of_tutee` int NOT NULL COMMENT 'number of tutees are allowed to enroll',
  `fee` double NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `enrollment` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `slot_id` integer NOT NULL,
  `tutee_id` integer NOT NULL,
  `signup_at` datetime NOT NULL DEFAULT (now()),
  `is_attended` boolean DEFAULT null,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `subject` (
  `id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `credit` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `payment` (
  `id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `tutee_id` int NOT NULL,
  `slot_id` int NOT NULL,
  `is_completed` boolean NOT NULL,
  `date_of_payment` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `feedback` (
  `id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `class_id` int NOT NULL,
  `rating_score` double,
  `comment` varchar(500),
  `last_edition_time` datetime NOT NULL,
  `type` ENUM ('class_rating', 'system_feedback') NOT NULL,
  `is_verified` boolean,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` boolean NOT NULL DEFAULT true
);

CREATE TABLE `system_picture` (
  `id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `picture_link` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (now()),
  `active` bool NOT NULL DEFAULT true
);

ALTER TABLE `user_info` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_score` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_score` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `class` ADD FOREIGN KEY (`tutor_id`) REFERENCES `user` (`id`);

ALTER TABLE `class` ADD FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

ALTER TABLE `class_schedule` ADD FOREIGN KEY (`class_id`) REFERENCES `class` (`id`);

ALTER TABLE `slot` ADD FOREIGN KEY (`class_schedule_id`) REFERENCES `class_schedule` (`id`);

ALTER TABLE `enrollment` ADD FOREIGN KEY (`slot_id`) REFERENCES `slot` (`id`);

ALTER TABLE `enrollment` ADD FOREIGN KEY (`tutee_id`) REFERENCES `user` (`id`);

ALTER TABLE `payment` ADD FOREIGN KEY (`tutee_id`) REFERENCES `user` (`id`);

ALTER TABLE `payment` ADD FOREIGN KEY (`slot_id`) REFERENCES `slot` (`id`);

ALTER TABLE `feedback` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `feedback` ADD FOREIGN KEY (`class_id`) REFERENCES `class` (`id`);

CREATE UNIQUE INDEX `class_index_0` ON `class` (`tutor_id`, `subject_id`);

CREATE UNIQUE INDEX `class_schedule_index_1` ON `class_schedule` (`class_id`, `date_occurring`);

CREATE UNIQUE INDEX `slot_index_2` ON `slot` (`start_time`, `end_time`);

CREATE UNIQUE INDEX `enrollment_index_3` ON `enrollment` (`slot_id`, `tutee_id`);

CREATE UNIQUE INDEX `payment_index_4` ON `payment` (`slot_id`, `tutee_id`);
