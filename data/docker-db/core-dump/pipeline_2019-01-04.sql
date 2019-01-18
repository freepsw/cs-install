# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 169.56.124.28 (MySQL 5.5.5-10.1.31-MariaDB)
# Database: pipeline
# Generation Time: 2019-01-04 02:13:56 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

use pipeline;
# Dump of table QUEUE_CLUSTER_INFO
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QUEUE_CLUSTER_INFO`;

CREATE TABLE `QUEUE_CLUSTER_INFO` (
  `CLUSTER_ID` int(11) NOT NULL AUTO_INCREMENT,
  `cluster_name` varchar(200) DEFAULT NULL,
  `ZOOKEEPER_URL` varchar(200) NOT NULL,
  `BOOTSTRAP_URL` varchar(200) DEFAULT NULL,
  `CREATE_DTM` datetime DEFAULT NULL,
  `MOD_DTM` datetime DEFAULT NULL,
  `CLIENT_ID` varchar(50) DEFAULT NULL COMMENT '사용자 계정 정보',
  `DHP_CLUSTER_ID` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CLUSTER_ID`),
  UNIQUE KEY `cluster_name` (`cluster_name`,`CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Kafka Cluster 정보를 관리한다';



# Dump of table TB_JDBC_INFO
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TB_JDBC_INFO`;

CREATE TABLE `TB_JDBC_INFO` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'JDBC 관리 ID',
  `NAME` varchar(50) NOT NULL COMMENT 'JDBC 관리 이름',
  `DRIVER` varchar(50) DEFAULT NULL COMMENT 'JDBC 드라이버 이름',
  `URL` varchar(100) DEFAULT NULL COMMENT 'JDBC URL',
  `TABLE_NAME` varchar(100) DEFAULT NULL COMMENT '테이블 명',
  `USER` varchar(100) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL COMMENT 'JDBC 접속 패스워드',
  `CLIENT_ID` varchar(50) DEFAULT NULL COMMENT '사용자 계정 정보',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `cluster_name` (`NAME`,`CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='JDBC 관리 정보';



# Dump of table TB_JOB_WORKFLOW_INFO
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TB_JOB_WORKFLOW_INFO`;

CREATE TABLE `TB_JOB_WORKFLOW_INFO` (
  `WORKFLOW_ID` int(11) NOT NULL COMMENT 'Global Workflow Id',
  `JOB_ID` int(11) NOT NULL COMMENT 'Global Job id',
  `STREAMING_JOB_ID` int(11) NOT NULL COMMENT '스트리밍 Job Id',
  `WORKFLOW_DEFINITION` mediumtext NOT NULL COMMENT 'workflow의 Json Data',
  `WORKFLOW_JSON` mediumtext NOT NULL COMMENT 'workflow의 GUI Json Data',
  `CREATE_DTM` datetime DEFAULT NULL COMMENT '생성 일시',
  PRIMARY KEY (`WORKFLOW_ID`,`STREAMING_JOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='스트리밍 Job별 이력(Workflow,GUI) 관리';



# Dump of table TB_WORKFLOW_COMP_INFO
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TB_WORKFLOW_COMP_INFO`;

CREATE TABLE `TB_WORKFLOW_COMP_INFO` (
  `COMP_UUID` varchar(40) NOT NULL COMMENT 'component의 uuid',
  `COMP_TYPE` varchar(10) NOT NULL COMMENT 'component의 type',
  `COMP_NAME` varchar(100) NOT NULL COMMENT 'component의 name',
  `WORKFLOW_ID` int(11) NOT NULL COMMENT 'workflow의 ID',
  `COMP_META_ID` int(11) NOT NULL COMMENT 'batch 모듈의 meta ID',
  `WORKFLOW_NAME` varchar(200) NOT NULL COMMENT 'batch 모듈이 소속된 Workflow 이름',
  `NOTI_LEVEL` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`COMP_UUID`),
  KEY `FK_WORKFLOW_ID` (`WORKFLOW_ID`),
  CONSTRAINT `FK_WORKFLOW_ID` FOREIGN KEY (`WORKFLOW_ID`) REFERENCES `TB_WORKFLOW_GUI_INFO` (`WORKFLOW_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='workflow compoents 정보';



# Dump of table TB_WORKFLOW_GUI_INFO
# ------------------------------------------------------------

DROP TABLE IF EXISTS `TB_WORKFLOW_GUI_INFO`;

CREATE TABLE `TB_WORKFLOW_GUI_INFO` (
  `WORKFLOW_ID` int(11) NOT NULL COMMENT 'workflow의 ID',
  `WORKFLOW_OWNER` varchar(50) NOT NULL COMMENT 'workflow의 작성자 ID',
  `WORKFLOW_JSON` mediumtext NOT NULL COMMENT 'workflow의 Json Data',
  `REG_DTM` datetime NOT NULL COMMENT '등록일시',
  `MOD_DTM` datetime NOT NULL COMMENT '수정일시',
  PRIMARY KEY (`WORKFLOW_ID`,`WORKFLOW_OWNER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='workflow GUI 정보(xy좌표, 이름, property key, error link 등)';




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
