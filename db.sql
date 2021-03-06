-- MySQL Script generated by MySQL Workbench
-- to. 26. mai 2016 kl. 20.47 +0200
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ehelse
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ehelse
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ehelse` DEFAULT CHARACTER SET utf8 ;
USE `ehelse` ;

-- -----------------------------------------------------
-- Table `ehelse`.`action`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`action` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 53
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`document_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`document_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`status` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 82
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`topic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`topic` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `title` VARCHAR(128) NOT NULL,
  `description` VARCHAR(256) NULL DEFAULT NULL,
  `sequence` INT(11) NOT NULL,
  `parent_id` INT(11) NULL DEFAULT NULL,
  `comment` VARCHAR(1024) NULL DEFAULT NULL,
  `is_archived` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`, `timestamp`),
  INDEX `fk_topic_topic1_idx` (`parent_id` ASC),
  CONSTRAINT `fk_topic_topic1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `ehelse`.`topic` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 229
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`document`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`document` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `title` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `sequence` INT(11) NOT NULL,
  `topic_id` INT(11) NOT NULL,
  `comment` VARCHAR(1024) NULL DEFAULT NULL,
  `status_id` INT(11) NULL DEFAULT NULL,
  `document_type_id` INT(11) NOT NULL,
  `standard_id` INT(11) NULL DEFAULT NULL,
  `prev_document_id` INT(11) NULL DEFAULT NULL,
  `is_archived` TINYINT(1) NOT NULL DEFAULT '0',
  `internal_id` VARCHAR(256) NULL DEFAULT NULL,
  `his_number` VARCHAR(256) NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `timestamp`),
  INDEX `fk_standard_topic1_idx` (`topic_id` ASC),
  INDEX `fk_document_status1_idx` (`status_id` ASC),
  INDEX `fk_document_document_type1_idx` (`document_type_id` ASC),
  INDEX `fk_document_document2_idx` (`prev_document_id` ASC),
  INDEX `fk_document_document1_idx` (`standard_id` ASC),
  CONSTRAINT `fk_document_document1`
    FOREIGN KEY (`standard_id`)
    REFERENCES `ehelse`.`document` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_document_document2`
    FOREIGN KEY (`prev_document_id`)
    REFERENCES `ehelse`.`document` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_document_document_type1`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `ehelse`.`document_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_document_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `ehelse`.`status` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_standard_topic1`
    FOREIGN KEY (`topic_id`)
    REFERENCES `ehelse`.`topic` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 312
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`document_field`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`document_field` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `sequence` INT(11) NOT NULL,
  `mandatory` TINYINT(1) NOT NULL,
  `document_type_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_document_field_document_type1_idx` (`document_type_id` ASC),
  CONSTRAINT `fk_document_field_document_type1`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `ehelse`.`document_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 166
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`document_field_value`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`document_field_value` (
  `document_field_id` INT(11) NOT NULL,
  `value` VARCHAR(1024) NOT NULL,
  `document_id` INT(11) NOT NULL,
  `document_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`document_field_id`, `document_id`, `document_timestamp`),
  INDEX `fk_document_version_field_value_document_field1_idx` (`document_field_id` ASC),
  INDEX `fk_document_field_value_document1_idx` (`document_id` ASC, `document_timestamp` ASC),
  CONSTRAINT `fk_document_field_value_document1`
    FOREIGN KEY (`document_id` , `document_timestamp`)
    REFERENCES `ehelse`.`document` (`id` , `timestamp`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_document_version_field_value_document_field1`
    FOREIGN KEY (`document_field_id`)
    REFERENCES `ehelse`.`document_field` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`mandatory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`mandatory` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`target_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`target_group` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `parent_id` INT(11) NULL DEFAULT NULL,
  `abbreviation` VARCHAR(128) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_target_group_target_group1_idx` (`parent_id` ASC),
  CONSTRAINT `fk_target_group_target_group1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `ehelse`.`target_group` (`id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`document_target_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`document_target_group` (
  `target_group_id` INT(11) NOT NULL,
  `deadline` VARCHAR(1024) NULL DEFAULT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `action_id` INT(11) NULL DEFAULT NULL,
  `mandatory_id` INT(11) NULL DEFAULT NULL,
  `document_id` INT(11) NOT NULL,
  `document_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`target_group_id`, `document_id`, `document_timestamp`),
  INDEX `fk_dokument_version_target_group_action1_idx` (`action_id` ASC),
  INDEX `fk_dokument_version_target_group_mandatory1_idx` (`mandatory_id` ASC),
  INDEX `fk_document_target_group_document1_idx` (`document_id` ASC, `document_timestamp` ASC),
  CONSTRAINT `fk_document_target_group_document1`
    FOREIGN KEY (`document_id` , `document_timestamp`)
    REFERENCES `ehelse`.`document` (`id` , `timestamp`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_dokument_version_target_group_action1`
    FOREIGN KEY (`action_id`)
    REFERENCES `ehelse`.`action` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_dokument_version_target_group_mandatory1`
    FOREIGN KEY (`mandatory_id`)
    REFERENCES `ehelse`.`mandatory` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_dokument_version_target_group_target_group1`
    FOREIGN KEY (`target_group_id`)
    REFERENCES `ehelse`.`target_group` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`link_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`link_category` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 28
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`link`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`link` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(128) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `url` VARCHAR(256) NOT NULL,
  `link_category_id` INT(11) NOT NULL,
  `document_id` INT(11) NOT NULL,
  `document_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `link_document_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `document_id`, `document_timestamp`),
  INDEX `fk_link_link_type1_idx` (`link_category_id` ASC),
  INDEX `fk_link_document1_idx` (`document_id` ASC, `document_timestamp` ASC),
  INDEX `fk_link_document2_idx` (`link_document_id` ASC),
  CONSTRAINT `fk_link_document1`
    FOREIGN KEY (`document_id` , `document_timestamp`)
    REFERENCES `ehelse`.`document` (`id` , `timestamp`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_link_document2`
    FOREIGN KEY (`link_document_id`)
    REFERENCES `ehelse`.`document` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_link_link_type1`
    FOREIGN KEY (`link_category_id`)
    REFERENCES `ehelse`.`link_category` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ehelse`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ehelse`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `profile_image` BLOB NULL DEFAULT NULL,
  `email` VARCHAR(128) NOT NULL,
  `password_hash` VARCHAR(256) NULL DEFAULT NULL,
  `pw_date_edited` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 81
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
