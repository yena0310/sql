CREATE TABLE `category` (
    `category_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(10) NOT NULL
);

CREATE TABLE `member` (
    `member_id` CHAR(100) NOT NULL PRIMARY KEY,
    `member_password` VARCHAR(60) NOT NULL, -- Increased length for hashed passwords
    `member_nickname` VARCHAR(25) NOT NULL,
    `member_name` VARCHAR(10) NOT NULL,
    `member_phone` VARCHAR(20) NOT NULL,
    `member_birth` DATE NOT NULL,
    `member_sex` BOOLEAN NOT NULL COMMENT '0 : 남성, 1 : 여성',
    `member_email` VARCHAR(100) NOT NULL,
    `member_photo` BLOB NULL,
    `member_code` CHAR(8) NOT NULL,
    `member_signDate` DATETIME NOT NULL,
    `member_point` INT UNSIGNED NULL
);

CREATE TABLE `instructor` (
    `instructor_id` CHAR(100) NOT NULL PRIMARY KEY,
    `instructor_password` VARCHAR(60) NOT NULL, -- Increased length for hashed passwords
    `instructor_nickname` VARCHAR(25) NOT NULL,
    `instructor_name` VARCHAR(10) NOT NULL,
    `instructor_phone` VARCHAR(20) NOT NULL,
    `instructor_publicContact` VARCHAR(20) NOT NULL,
    `instructor_email` VARCHAR(100) NULL,
    `instructor_introduce` VARCHAR(100) NULL,
    `instructor_photo` BLOB NULL
);

CREATE TABLE `class` (
    `class_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `class_name` VARCHAR(50) NOT NULL,
    `class_introduce` VARCHAR(255) NOT NULL,
    `class_location` VARCHAR(255) NOT NULL,
    `class_price` INT UNSIGNED NOT NULL,
    `class_parking` BOOLEAN NULL COMMENT '1 : 가능 0 : 불가능',
    `class_limit` TINYINT UNSIGNED NOT NULL,
    `class_ageLimit` TINYINT UNSIGNED NULL,
    `class_takenTime` SMALLINT UNSIGNED NOT NULL,
    `class_photo` BLOB NULL,
    `category_id` TINYINT UNSIGNED NOT NULL,
    `instructor_id` CHAR(100) NOT NULL,
    FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
    FOREIGN KEY (`instructor_id`) REFERENCES `instructor` (`instructor_id`)
);

CREATE TABLE `schedule` (
    `schedule_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `schedule_datetime` DATETIME NOT NULL,
    `schedule_headcount` TINYINT UNSIGNED NOT NULL,
    `class_id` INT NOT NULL,
    FOREIGN KEY (`class_id`) REFERENCES `class`(`class_id`)
);

CREATE TABLE `reservation` (
    `reservation_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `reservation_datetime` DATETIME NOT NULL,
    `reservation_headcount` TINYINT UNSIGNED NOT NULL,
    `schedule_id` INT NOT NULL,
    `member_id` CHAR(100) NOT NULL,
    FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`schedule_id`),
    FOREIGN KEY (`member_id`) REFERENCES `member`(`member_id`)
);

CREATE TABLE `payment` (
    `reservation_id` INT NOT NULL PRIMARY KEY,
    `pay_coupon` INT UNSIGNED NOT NULL DEFAULT 0,
    `pay_point` INT UNSIGNED NOT NULL DEFAULT 0,
    `pay_cost` INT UNSIGNED NOT NULL,
    `paymentMethod_id` INT UNSIGNED NOT NULL,
    `pay_complete` BOOLEAN NOT NULL COMMENT '1 : 완료 0 : 미완료',
    FOREIGN KEY (`reservation_id`) REFERENCES `reservation`(`reservation_id`)
);

CREATE TABLE `review` (
    `reservation_id` INT NOT NULL PRIMARY KEY,
    `review_satisfaction` TINYINT UNSIGNED NOT NULL DEFAULT 100,
    `review_level` VARCHAR(5) NOT NULL,
    `review_explanation` VARCHAR(5) NOT NULL,
    `review_result` VARCHAR(7) NOT NULL,
    `review_description` TEXT NOT NULL,
    `review_photo` BLOB NULL,
    `review_isReported` BOOLEAN NULL DEFAULT 0 COMMENT '1 : 신고 0 : 미신고',
    `review_recommendation` SMALLINT UNSIGNED NULL DEFAULT 0,
    FOREIGN KEY (`reservation_id`) REFERENCES `reservation`(`reservation_id`)
);

CREATE TABLE `couponInfo` (
    `coupon_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `coupon_negoPrice` INT UNSIGNED NOT NULL,
    `coupon_name` VARCHAR(20) NOT NULL,
    `coupon_validTime` SMALLINT UNSIGNED NOT NULL,
    `coupon_priceLimit` MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    `coupon_detail` VARCHAR(100) NULL
);

CREATE TABLE `coupon` (
    `coupon_id` INT NOT NULL PRIMARY KEY,
    `member_id` CHAR(100) NOT NULL,
    `coupon_startDate` DATETIME NOT NULL,
    `coupon_isExpired` BOOLEAN NOT NULL DEFAULT 0 COMMENT '1 : 만료 0 : 유효',
    `coupon_isUsed` BOOLEAN NOT NULL DEFAULT 0 COMMENT '1 : 사용 0 : 미사용',
    FOREIGN KEY (`coupon_id`) REFERENCES `couponInfo`(`coupon_id`),
    FOREIGN KEY (`member_id`) REFERENCES `member`(`member_id`)
);

CREATE TABLE `paymentMethod` (
    `paymentMethod_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `paymentMethod_name` VARCHAR(10) NOT NULL,
    `rewarding_percentage` DECIMAL(4,3) NOT NULL
);

CREATE TABLE `rewardingPoint` (
    `reservation_id` INT NOT NULL PRIMARY KEY,
    `rewarding_point` INT UNSIGNED NOT NULL,
    `rewarding_date` DATE NOT NULL,
    `extinction_date` DATE NOT NULL,
    FOREIGN KEY (`reservation_id`) REFERENCES `payment`(`reservation_id`)
);

CREATE TABLE `classAsk` (
    `classAsk_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `classAsk_content` VARCHAR(500) NOT NULL,
    `classAsk_date` DATE NOT NULL,
    `class_id` INT UNSIGNED NOT NULL,
    FOREIGN KEY (`class_id`) REFERENCES `class`(`class_id`)
);

CREATE TABLE `classAnswer` (
    `classAsk_id` INT NOT NULL PRIMARY KEY,
    `classAnswer_content` VARCHAR(500) NOT NULL,
    `classAnswer_date` DATE NOT NULL,
    FOREIGN KEY (`classAsk_id`) REFERENCES `classAsk`(`classAsk_id`)
);

CREATE TABLE `groupAsk` (
    `groupAsk_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `groupAsk_date` DATE NOT NULL,
    `groupAsk_reservationDate` DATE NOT NULL,
    `groupAsk_reservationHeadcount` TINYINT UNSIGNED NOT NULL,
    `groupAsk_reservationTime` TIME NOT NULL,
    `groupAsk_takenTime` SMALLINT UNSIGNED NOT NULL,
    `groupAsk_maxPrice` INT UNSIGNED NOT NULL,
    `groupAsk_request` VARCHAR(500) NULL,
    `groupAsk_isConfirmed` BOOLEAN NOT NULL COMMENT '1 : 확정 0 : 미확정',
    `member_id` CHAR(100) NOT NULL,
    FOREIGN KEY (`member_id`) REFERENCES `memeber`(`member_id`)
);

CREATE TABLE 'groupAnswer' (
    'groupAsk_id' INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    'groupAnswer_date' DATE NOT NULL,
    'groupAnswer_price' INT NOT NULL UNSIGNED,
    'groupAnswer_note' VARCHAR(500) NULL,
    'groupAnswer_isConfirmed' BOOLEAN NOT NULL COMMENT '1 : 승인 0 : 미승인'
);

CREATE TABLE `reservationAsk` (
    `reservationAsk_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `reservationAsk_content` VARCHAR(500) NOT NULL,
    `reservationAsk_date` DATE NOT NULL,
    `class_id` INT UNSIGNED NOT NULL,
    FOREIGN KEY (`class_id`) REFERENCES `class`(`class_id`)
);

CREATE TABLE 'reservationAnswer' (
    'reservationAsk_id' INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    'reservationAnswer_isConfirmed' BOOLEAN NOT NULL COMMENT '1 : 승인 0 : 미승인',
    'reservationAnswer_rejectReason' VARCHAR(500) NOT NULL
);