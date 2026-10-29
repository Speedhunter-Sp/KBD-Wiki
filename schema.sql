-- Keeb Wiki database schema
-- Import this in phpMyAdmin (or `mysql -u root < schema.sql`) before using the app.

CREATE DATABASE IF NOT EXISTS keeb_wiki CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE keeb_wiki;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS keyboards (
    id INT PRIMARY KEY AUTO_INCREMENT,

    -- identity
    name VARCHAR(150) NOT NULL,          -- e.g. "Project Darling"
    model VARCHAR(150),                  -- e.g. "TM680"
    photo VARCHAR(255),                  -- main/hero photo, stored filename

    -- spec grid
    layout VARCHAR(100),
    frame_color VARCHAR(100),
    frame_swap VARCHAR(150),
    plate_type VARCHAR(100),
    pcb_type VARCHAR(100),               -- north/south facing etc
    mounting_style VARCHAR(100),         -- tray, gasket, o-ring, top mount...
    switches VARCHAR(150),
    keycaps VARCHAR(150),                -- profile/material, e.g. "Cherry profile, PBT"
    keycap_set VARCHAR(150),             -- the named set, e.g. "GMK Oblivion"
    connection_type VARCHAR(100),        -- wired / bluetooth / tri-mode
    battery_size VARCHAR(100),
    hotswap VARCHAR(50),                 -- No / Yes - 3-pin / Yes - 5-pin
    special_features VARCHAR(255),       -- knob, screen, etc

    -- lineage: this build used to be a different build
    formerly_known_as_id INT NULL,

    -- long-form wiki content
    intro_paragraph TEXT,
    description TEXT,
    build_timeline TEXT,
    personal_review TEXT,
    future_build_plans TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_formerly_known_as
        FOREIGN KEY (formerly_known_as_id) REFERENCES keyboards(id)
        ON DELETE SET NULL
);

-- extra photos beyond the one hero photo, shown as a gallery on the keyboard page
CREATE TABLE IF NOT EXISTS keyboard_photos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    keyboard_id INT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (keyboard_id) REFERENCES keyboards(id) ON DELETE CASCADE
);

-- tags (layout, connectivity, whatever you like), for search/filter on the homepage
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
