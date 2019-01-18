# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 169.56.124.28 (MySQL 5.5.5-10.1.31-MariaDB)
# Database: dpcore_collector
# Generation Time: 2019-01-04 02:11:41 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

use dpcore_collector;

# Dump of table COLLECTOR_AUTH
# ------------------------------------------------------------

DROP TABLE IF EXISTS `COLLECTOR_AUTH`;

CREATE TABLE `COLLECTOR_AUTH` (
  `collectorId` int(11) NOT NULL,
  `user` varchar(50) NOT NULL,
  `userGroup` varchar(50) DEFAULT NULL,
  `role` varchar(3) NOT NULL,
  PRIMARY KEY (`collectorId`,`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table COLLECTOR_CONFIG
# ------------------------------------------------------------

DROP TABLE IF EXISTS `COLLECTOR_CONFIG`;

CREATE TABLE `COLLECTOR_CONFIG` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT,
  `collector_id` int(11) NOT NULL,
  `file_name` varchar(200) DEFAULT NULL,
  `input_type` varchar(200) DEFAULT NULL,
  `input_parameters` mediumtext,
  `filter_type` varchar(200) DEFAULT NULL,
  `filter_parameters` mediumtext,
  `output_type` varchar(200) DEFAULT NULL,
  `output_parameters` mediumtext,
  `configuration` text,
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `COLLECTOR_CONFIG_collector_id_uindex` (`collector_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table COLLECTOR_INSTANCE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `COLLECTOR_INSTANCE`;

CREATE TABLE `COLLECTOR_INSTANCE` (
  `collector_id` int(11) NOT NULL AUTO_INCREMENT,
  `collector_name` varchar(200) NOT NULL,
  `collector_type` varchar(200) NOT NULL,
  `host_name` varchar(200) NOT NULL,
  `port` int(11) DEFAULT NULL,
  `pid` varchar(10) DEFAULT NULL,
  `monitoring_type` varchar(10) DEFAULT NULL,
  `monitoring_port` int(11) DEFAULT NULL,
  `status` varchar(10) DEFAULT 'STOP',
  `last_operation_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `client_id` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`collector_id`),
  UNIQUE KEY `collector_unique` (`collector_name`,`host_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table HOSTS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `HOSTS`;

CREATE TABLE `HOSTS` (
  `host_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_name` varchar(200) NOT NULL,
  `user_name` varchar(200) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `ssh_port` int(11) DEFAULT NULL,
  `flume_home` varchar(200) DEFAULT NULL,
  `logstash_home` varchar(200) DEFAULT NULL,
  `client_id` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`host_id`),
  UNIQUE KEY `HOSTS_host_name_client_uindex` (`host_name`,`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
