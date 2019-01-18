# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 169.56.124.28 (MySQL 5.5.5-10.1.31-MariaDB)
# Database: dpcore_common
# Generation Time: 2019-01-04 02:11:20 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table COMMON_AUTH
# ------------------------------------------------------------

DROP TABLE IF EXISTS `COMMON_AUTH`;

CREATE TABLE `COMMON_AUTH` (
  `authId` varchar(50) NOT NULL,
  `service` varchar(50) NOT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `user` varchar(50) NOT NULL,
  `userGroup` varchar(50) DEFAULT NULL,
  `role` varchar(3) NOT NULL,
  PRIMARY KEY (`authId`,`service`,`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table COMMON_CLUSTER
# ------------------------------------------------------------

DROP TABLE IF EXISTS `COMMON_CLUSTER`;

CREATE TABLE `COMMON_CLUSTER` (
  `clusterId` bigint(20) NOT NULL AUTO_INCREMENT,
  `clustername` varchar(255) NOT NULL,
  `clientId` varchar(255) NOT NULL,
  `config` text NOT NULL,
  `createTime` int(11) NOT NULL,
  `updateTime` int(11) NOT NULL,
  PRIMARY KEY (`clusterId`),
  KEY `idx_common_cluster_clustername` (`clustername`),
  KEY `idx_common_cluster_clientId` (`clientId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table log4j_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `log4j_history`;

CREATE TABLE `log4j_history` (
  `app_id` varchar(50) NOT NULL,
  `app_name` varchar(100) NOT NULL,
  `app_type` varchar(50) NOT NULL,
  `log_time` datetime(3) DEFAULT NULL,
  `log_level` varchar(10) DEFAULT NULL,
  `thread_name` varchar(100) DEFAULT NULL,
  `message` text,
  KEY `idx_log4j_history_app_id` (`app_id`),
  KEY `idx_log4j_history_app_name` (`app_name`),
  KEY `idx_log4j_history_app_type` (`app_type`),
  KEY `idx_log4j_history_log_time` (`log_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
