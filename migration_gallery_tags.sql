-- Run this ONLY if you already imported the original schema.sql and have
-- keyboards in your database. It just adds the new gallery + tags tables
-- without touching anything you've already entered.
--
-- In phpMyAdmin: select the keeb_wiki database, click Import, choose this file.

USE keeb_wiki;

CREATE TABLE IF NOT EXISTS keyboard_photos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    keyboard_id INT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (keyboard_id) REFERENCES keyboards(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS keyboard_tags (
    keyboard_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (keyboard_id, tag_id),
    FOREIGN KEY (keyboard_id) REFERENCES keyboards(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);
