CREATE TABLE discuss (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(32),
    description VARCHAR(100) NOT NULL,
    post_by VARCHAR(32) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    updated_at INT UNSIGNED NOT NULL,
    index (name),
    index (description)
) ENGINE=InnoDB, DEFAULT CHAR SET=utf8; 

