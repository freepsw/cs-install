# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 169.56.124.28 (MySQL 5.5.5-10.1.31-MariaDB)
# Database: dpcore_globalworkflow
# Generation Time: 2019-01-04 02:09:07 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

use dpcore_globalworkflow;

# Dump of table GLOBALWORKFLOW_AUTH
# ------------------------------------------------------------

DROP TABLE IF EXISTS `GLOBALWORKFLOW_AUTH`;

CREATE TABLE `GLOBALWORKFLOW_AUTH` (
  `workflowId` int(11) NOT NULL,
  `user` varchar(50) NOT NULL,
  `userGroup` varchar(50) DEFAULT NULL,
  `role` varchar(3) NOT NULL,
  PRIMARY KEY (`workflowId`,`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table GLOBALWORKFLOW_JOB
# ------------------------------------------------------------

DROP TABLE IF EXISTS `GLOBALWORKFLOW_JOB`;

CREATE TABLE `GLOBALWORKFLOW_JOB` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `workflowId` int(11) NOT NULL,
  `status` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `startTime` int(11) DEFAULT NULL,
  `endTime` int(11) DEFAULT NULL,
  `componentId` int(11) DEFAULT NULL,
  `componentType` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `componentSubType` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `componentJobId` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `componentName` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `GLOBALWORKFLOW_JOB_uuid_uindex` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table GLOBALWORKFLOW_WORKFLOW
# ------------------------------------------------------------

DROP TABLE IF EXISTS `GLOBALWORKFLOW_WORKFLOW`;

CREATE TABLE `GLOBALWORKFLOW_WORKFLOW` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(120) DEFAULT 'default',
  `name` varchar(120) DEFAULT NULL,
  `creator` varchar(120) NOT NULL,
  `description` tinytext,
  `createTime` int(11) NOT NULL,
  `updateTime` int(11) NOT NULL,
  `workflowDefinition` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
