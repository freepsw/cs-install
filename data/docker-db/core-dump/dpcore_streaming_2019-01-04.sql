# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 169.56.124.28 (MySQL 5.5.5-10.1.31-MariaDB)
# Database: dpcore_streaming
# Generation Time: 2019-01-04 02:13:02 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

use dpcore_streaming;

# Dump of table streaming_workflow
# ------------------------------------------------------------

DROP TABLE IF EXISTS `streaming_workflow`;

CREATE TABLE `streaming_workflow` (
  `workflow_id` int(100) NOT NULL AUTO_INCREMENT,
  `workflow_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `batch_duration` int(3) NOT NULL,
  `driver_memory` varchar(10) NOT NULL,
  `driver_cores` int(3) NOT NULL,
  `executor_memory` varchar(10) NOT NULL,
  `executor_cores` int(3) NOT NULL,
  `executor_numbers` int(3) NOT NULL,
  `thrift_port` int(5) NOT NULL,
  `queue` varchar(100) DEFAULT NULL,
  `model` varchar(10000) DEFAULT NULL,
  `client_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`workflow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


# Dump of table streaming_branch
# ------------------------------------------------------------

DROP TABLE IF EXISTS `streaming_branch`;

CREATE TABLE `streaming_branch` (
  `branch_id` int(100) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(100) NOT NULL,
  `branch_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `branch_seq` int(10) NOT NULL,
  PRIMARY KEY (`branch_id`),
  KEY `workflow_id` (`workflow_id`),
  CONSTRAINT `streaming_branch_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `streaming_workflow` (`workflow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table streaming_component
# ------------------------------------------------------------

DROP TABLE IF EXISTS `streaming_component`;

CREATE TABLE `streaming_component` (
  `component_id` int(100) NOT NULL AUTO_INCREMENT,
  `branch_id` int(100) NOT NULL,
  `workflow_id` int(100) NOT NULL,
  `category` varchar(20) DEFAULT NULL,
  `component_type` varchar(20) NOT NULL,
  `component_name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `component_seq` int(10) NOT NULL,
  `properties` mediumtext CHARACTER SET utf8,
  `component_uuid` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`component_id`),
  KEY `branch_id` (`branch_id`),
  KEY `streaming_component_ibfk_2` (`workflow_id`),
  CONSTRAINT `streaming_component_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `streaming_branch` (`branch_id`),
  CONSTRAINT `streaming_component_ibfk_2` FOREIGN KEY (`workflow_id`) REFERENCES `streaming_workflow` (`workflow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table streaming_job
# ------------------------------------------------------------

DROP TABLE IF EXISTS `streaming_job`;

CREATE TABLE `streaming_job` (
  `job_id` int(100) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(100) NOT NULL,
  `session_id` int(100) NOT NULL,
  `driver_host` varchar(100) DEFAULT NULL,
  `container_id` varchar(100) DEFAULT NULL,
  `app_id` varchar(50) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `state` varchar(150) DEFAULT NULL,
  `start_dt` datetime DEFAULT NULL,
  `end_dt` datetime DEFAULT NULL,
  `client_id` varchar(100) DEFAULT NULL,
  `dynamic_config` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`job_id`),
  KEY `workflow_id` (`workflow_id`),
  CONSTRAINT `streaming_job_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `streaming_workflow` (`workflow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table streaming_meta
# ------------------------------------------------------------

DROP TABLE IF EXISTS `streaming_meta`;

CREATE TABLE `streaming_meta` (
  `meta_id` int(100) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(100) NOT NULL,
  `meta_type` varchar(20) NOT NULL,
  `meta_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `meta_table` varchar(50) NOT NULL,
  `properties` varchar(5000) CHARACTER SET utf8 DEFAULT NULL,
  `component_uuid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `workflow_id` (`workflow_id`),
  CONSTRAINT `streaming_meta_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `streaming_workflow` (`workflow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table streaming_mon_batch
# ------------------------------------------------------------

DROP TABLE IF EXISTS `streaming_mon_batch`;

CREATE TABLE `streaming_mon_batch` (
  `mon_batch_id` int(100) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(100) NOT NULL,
  `start_dt` datetime(3) DEFAULT NULL,
  `end_dt` datetime(3) DEFAULT NULL,
  `duration` mediumint(9) DEFAULT NULL,
  `throughput` mediumint(9) DEFAULT NULL,
  `accum_size` int(11) DEFAULT NULL,
  PRIMARY KEY (`mon_batch_id`),
  KEY `idx1` (`workflow_id`),
  KEY `idx2` (`start_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table streaming_mon_component
# ------------------------------------------------------------

DROP TABLE IF EXISTS `streaming_mon_component`;

CREATE TABLE `streaming_mon_component` (
  `mon_component_id` int(100) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(100) NOT NULL,
  `component_id` int(100) NOT NULL,
  `start_dt` datetime(3) DEFAULT NULL,
  `end_dt` datetime(3) DEFAULT NULL,
  `duration` mediumint(9) DEFAULT NULL,
  `throughput` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`mon_component_id`),
  KEY `idx3` (`workflow_id`),
  KEY `idx4` (`start_dt`),
  KEY `idx5` (`component_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;






/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
