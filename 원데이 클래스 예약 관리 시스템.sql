CREATE TABLE `카테고리` (
    `category_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `category_name` VARCHAR(10) NOT NULL,
    PRIMARY KEY (`category_id`) 
);

CREATE TABLE `회원` (
    `member_id` CHAR(100) NOT NULL,
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
    `member_point` INT UNSIGNED NULL,
    PRIMARY KEY (`member_id`)
);

CREATE TABLE `작가` (
    `instructor_id` CHAR(100) NOT NULL,
    `instructor_password` VARCHAR(60) NOT NULL, -- Increased length for hashed passwords
    `instructor_nickname` VARCHAR(25) NOT NULL,
    `instructor_name` VARCHAR(10) NOT NULL,
    `instructor_phone` VARCHAR(20) NOT NULL,
    `instructor_publicContact` VARCHAR(20) NOT NULL,
    `instructor_email` VARCHAR(100) NULL,
    `instructor_introduce` VARCHAR(100) NULL,
    `instructor_photo` BLOB NULL,
    PRIMARY KEY (`instructor_id`)
);

CREATE TABLE `클래스` (
    `class_id` INT NOT NULL AUTO_INCREMENT,
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
    PRIMARY KEY (`class_id`),
    FOREIGN KEY (`category_id`) REFERENCES `카테고리` (`category_id`),
    FOREIGN KEY (`instructor_id`) REFERENCES `작가` (`instructor_id`)
);

CREATE TABLE `스케쥴` (
    `schedule_id` INT NOT NULL AUTO_INCREMENT,
    `schedule_datetime` DATETIME NOT NULL,
    `schedule_headcount` TINYINT UNSIGNED NOT NULL,
    `class_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`schedule_id`),
    FOREIGN KEY (`class_id`) REFERENCES `클래스`(`class_id`)
);

CREATE TABLE `예약` (
    `reservation_id` INT NOT NULL AUTO_INCREMENT,
    `reservation_datetime` DATETIME NOT NULL,
    `reservation_headcount` TINYINT UNSIGNED NOT NULL,
    `schedule_id` INT UNSIGNED NOT NULL,
    `member_id` CHAR(100) NOT NULL,
    PRIMARY KEY (`reservation_id`),
    FOREIGN KEY (`schedule_id`) REFERENCES `스케쥴`(`schedule_id`),
    FOREIGN KEY (`member_id`) REFERENCES `회원`(`member_id`)
);
CREATE TABLE `결제` (
    `reservation_id` INT NOT NULL,
    `pay_coupon` INT UNSIGNED NOT NULL DEFAULT 0,
    `pay_point` INT UNSIGNED NOT NULL DEFAULT 0,
    `pay_cost` INT UNSIGNED NOT NULL,
    `paymentMethod_id` INT UNSIGNED NOT NULL,
    `pay_complete` BOOLEAN NOT NULL COMMENT '1 : 완료 0 : 미완료',
    PRIMARY KEY (`reservation_id`),
    FOREIGN KEY (`reservation_id`) REFERENCES `예약`(`reservation_id`)
);
CREATE TABLE `후기` (
    `reservation_id` INT NOT NULL,
    `review_satisfaction` TINYINT UNSIGNED NOT NULL DEFAULT 100,
    `review_level` VARCHAR(5) NOT NULL,
    `review_explanation` VARCHAR(5) NOT NULL,
    `review_result` VARCHAR(7) NOT NULL,
    `review_description` TEXT NOT NULL,
    `review_photo` BLOB NULL,
    `review_isReported` BOOLEAN NULL DEFAULT 0 COMMENT '1 : 신고 0 : 미신고',
    `review_recommendation` SMALLINT UNSIGNED NULL DEFAULT 0,
    PRIMARY KEY (`reservation_id`),
    FOREIGN KEY (`reservation_id`) REFERENCES `예약`(`reservation_id`)
);
CREATE TABLE `쿠폰정보` (
    `coupon_id` INT NOT NULL AUTO_INCREMENT,
    `coupon_negoPrice` INT UNSIGNED NOT NULL,
    `coupon_name` VARCHAR(20) NOT NULL,
    `coupon_validTime` SMALLINT UNSIGNED NOT NULL,
    `coupon_priceLimit` MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    `coupon_detail` VARCHAR(100) NULL,
    PRIMARY KEY (`coupon_id`)
);
CREATE TABLE `쿠폰` (
    `coupon_id` INT NOT NULL,
    `member_id` CHAR(100) NOT NULL,
    `coupon_startDate` DATETIME NOT NULL,
    `coupon_isExpired` BOOLEAN NOT NULL DEFAULT 0 COMMENT '1 : 만료 0 : 유효',
    `coupon_isUsed` BOOLEAN NOT NULL DEFAULT 0 COMMENT '1 : 사용 0 : 미사용',
    PRIMARY KEY (`coupon_id`),
    FOREIGN KEY (`coupon_id`) REFERENCES `쿠폰정보`(`coupon_id`),
    FOREIGN KEY (`member_id`) REFERENCES `회원`(`member_id`)
);
CREATE TABLE `결제 방법` (
    `paymentMethod_id` INT NOT NULL AUTO_INCREMENT,
    `paymentMethod_name` VARCHAR(10) NOT NULL,
    `rewarding_percentage` DECIMAL(4,3) NOT NULL,
    PRIMARY KEY (`paymentMethod_id`)
);
CREATE TABLE `포인트적립` (
    `reservation_id` INT NOT NULL,
    `rewarding_point` INT UNSIGNED NOT NULL,
    `rewarding_date` DATE NOT NULL,
    `extinction_date` DATE NOT NULL,
    PRIMARY KEY (`reservation_id`),
    FOREIGN KEY (`reservation_id`) REFERENCES `결제`(`reservation_id`)
);

CREATE TABLE `클래스 문의` (
    `classAsk_id` INT NOT NULL AUTO_INCREMENT,
    `classAsk_content` VARCHAR(500) NOT NULL,
    `classAsk_date` DATE NOT NULL,
    `class_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`classAsk_id`),
    FOREIGN KEY (`class_id`) REFERENCES `클래스`(`class_id`)
);

CREATE TABLE `클래스 답변` (
    `classAsk_id` INT NOT NULL,
    `classAnswer_content` VARCHAR(500) NOT NULL,
    `classAnswer_date` DATE NOT NULL,
    PRIMARY KEY (`classAsk_id`),
    FOREIGN KEY (`classAsk_id`) REFERENCES `클래스 문의`(`classAsk_id`)
);

CREATE TABLE `그룹예약 문의` (
    `groupAsk_id` INT NOT NULL AUTO_INCREMENT,
    `groupAsk_date` DATE NOT NULL,
    `groupAsk_reservationDate` DATE NOT NULL,
    `groupAsk_reservationHeadcount` TINYINT UNSIGNED NOT NULL,
    `groupAsk_reservationTime` TIME NOT NULL,
    `groupAsk_takenTime` SMALLINT UNSIGNED NOT NULL,
    `groupAsk_maxPrice` INT UNSIGNED NOT NULL,
    `groupAsk_request` VARCHAR(500) NULL,
    `groupAsk_isConfirmed` BOOLEAN NOT NULL COMMENT '1 : 확정 0 : 미확정',
    `member_id` CHAR(100) NOT NULL,
    PRIMARY KEY (`groupAsk_id`),
    FOREIGN KEY (`member_id`) REFERENCES `회원`(`member_id`)
);

CREATE TABLE `예약날짜 문의` (
    `reservationAsk_id` INT NOT NULL AUTO_INCREMENT,
    `reservationAsk_content` VARCHAR(500) NOT NULL,
    `reservationAsk_date` DATE NOT NULL,
    `class_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`reservationAsk_id`),
    FOREIGN KEY (`class_id`) REFERENCES `클래스`(`class_id`)
);