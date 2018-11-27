-- MySQL dump 10.16  Distrib 10.1.36-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: dpcore_search
-- ------------------------------------------------------
-- Server version	10.1.36-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `BUILT_IN_SERVICE_COLLECT_LIST`
--

DROP TABLE IF EXISTS `BUILT_IN_SERVICE_COLLECT_LIST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BUILT_IN_SERVICE_COLLECT_LIST` (
  `BUILT_IN_SERVICE_ID` int(11) NOT NULL,
  `COLLECT_SERVER_IP` varchar(15) NOT NULL,
  `COLLECT_SERVER_PORT` int(11) NOT NULL,
  `COLLECT_SERVER_USER_ID` varchar(50) NOT NULL,
  `COLLECT_SERVER_USER_PW` varchar(50) DEFAULT NULL,
  `PID` varchar(10) DEFAULT NULL,
  `STATUS` varchar(20) DEFAULT 'Active' COMMENT '1: active,   0: dead,     else: unknown',
  PRIMARY KEY (`BUILT_IN_SERVICE_ID`,`COLLECT_SERVER_IP`),
  CONSTRAINT `fk_BUILT_IN_SERVICE_COLLECT_LIST_BUILT_IN_SERVICE_LIST1` FOREIGN KEY (`BUILT_IN_SERVICE_ID`) REFERENCES `BUILT_IN_SERVICE_LIST` (`BUILT_IN_SERVICE_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Built in service를 설치할 서버 목록 (하나의 built in service를 여러대 서버에 설치 가능)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BUILT_IN_SERVICE_COLLECT_LIST`
--

LOCK TABLES `BUILT_IN_SERVICE_COLLECT_LIST` WRITE;
/*!40000 ALTER TABLE `BUILT_IN_SERVICE_COLLECT_LIST` DISABLE KEYS */;
/*!40000 ALTER TABLE `BUILT_IN_SERVICE_COLLECT_LIST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BUILT_IN_SERVICE_LIST`
--

DROP TABLE IF EXISTS `BUILT_IN_SERVICE_LIST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BUILT_IN_SERVICE_LIST` (
  `BUILT_IN_SERVICE_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Auto Increment를 이용한 primary key 자동 생성',
  `SERVICE_TYPE_ID` varchar(3) NOT NULL,
  `CLUSTER_ID` int(11) NOT NULL,
  `DASHBOARD_LINK` varchar(3000) DEFAULT NULL COMMENT '수집한 로그를 시각화 해주는 kibana 대시보드 링크',
  `CONFIG_STRING` varchar(3000) DEFAULT NULL,
  `CREATE_DT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BUILT_IN_SERVICE_ID`,`CLUSTER_ID`),
  UNIQUE KEY `BUILT_IN_SERVICE_ID_UNIQUE` (`BUILT_IN_SERVICE_ID`),
  KEY `fk_BUILT_IN_SERVICE_LIST_BUILT_IN_SERVICE_TYPE1_idx` (`SERVICE_TYPE_ID`),
  KEY `fk_BUILT_IN_SERVICE_LIST_ES_CLUSTER_LIST1_idx` (`CLUSTER_ID`),
  CONSTRAINT `fk_BUILT_IN_SERVICE_LIST_BUILT_IN_SERVICE_TYPE1` FOREIGN KEY (`SERVICE_TYPE_ID`) REFERENCES `BUILT_IN_SERVICE_TYPE` (`SERVICE_TYPE_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_BUILT_IN_SERVICE_LIST_ES_CLUSTER_LIST1` FOREIGN KEY (`CLUSTER_ID`) REFERENCES `ES_CLUSTER_LIST` (`CLUSTER_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='Elasticsearch cluster에 데이터를 저장 및 시각화하는 서비스 목록';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BUILT_IN_SERVICE_LIST`
--

LOCK TABLES `BUILT_IN_SERVICE_LIST` WRITE;
/*!40000 ALTER TABLE `BUILT_IN_SERVICE_LIST` DISABLE KEYS */;
/*!40000 ALTER TABLE `BUILT_IN_SERVICE_LIST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BUILT_IN_SERVICE_TYPE`
--

DROP TABLE IF EXISTS `BUILT_IN_SERVICE_TYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BUILT_IN_SERVICE_TYPE` (
  `SERVICE_TYPE_ID` varchar(3) NOT NULL COMMENT '\n001 : 서버 모니터링 (metricbeat)\n002 : MySQL 모니터링\n003 : Apache2 로그 모니터링\n004 : Kafka 로그 모니터링\n005 : 로그 수집 (filebeat) - kibana 대시보는 없음',
  `NAME` varchar(45) DEFAULT NULL COMMENT 'Service 명\nTomcat',
  `DESC` varchar(2000) DEFAULT NULL COMMENT 'Built-in service에 대한 상세설명',
  `COLLECTOR_INFO` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`SERVICE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='built-in 서비스 유형을 정의 (별도 테이블이 필요할까?)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BUILT_IN_SERVICE_TYPE`
--

LOCK TABLES `BUILT_IN_SERVICE_TYPE` WRITE;
/*!40000 ALTER TABLE `BUILT_IN_SERVICE_TYPE` DISABLE KEYS */;
INSERT INTO `BUILT_IN_SERVICE_TYPE` VALUES ('001','System monitoring','Monitoring Server using metricbeat','metric beat'),('002','MySQL monitoring','Monitoring MySQL using metricbeat','metric beat'),('003','Apache2 Log monitoring','Monitoring Apache2 logs using filebeat','file beat'),('004','Kafka  monitoring','Monitoring Kafka logs using filebeat','metric beat'),('005','Log collecting','collect logs to es','log stash');
/*!40000 ALTER TABLE `BUILT_IN_SERVICE_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COM_CODE`
--

DROP TABLE IF EXISTS `COM_CODE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `COM_CODE` (
  `GROUP_CODE` varchar(20) NOT NULL COMMENT 'A0001',
  `DETAIL_CODE` varchar(20) NOT NULL COMMENT '그룹코드에 포함된 실제 코드 목록',
  `DISPLAY_SEQ` int(11) NOT NULL COMMENT '화면에 출력되는 순서',
  `P_DETAIL_CODE` varchar(20) DEFAULT NULL COMMENT '그룹간의 계층관계를 표현하기 위한 용도',
  `GRROUP_CODE_DESC` varchar(1000) DEFAULT NULL COMMENT '그룹코드의 명칭\n“성별코드”\n“서비스 타입” 등',
  `CODE_NAME` varchar(1000) NOT NULL COMMENT '상세 코드 명\nM : 남성\nF : 여성',
  `CODE_CHAR_VALUE_ONE` varchar(200) DEFAULT NULL COMMENT '코드 문자값',
  `CODE_CHAR_VALUE_TWO` varchar(200) DEFAULT NULL COMMENT '코드 문자값',
  `CODE_CHAR_VALUE_THREE` varchar(200) DEFAULT NULL COMMENT '코드 문자값',
  `CODE_CHAR_VALUE_FOUR` varchar(200) DEFAULT NULL COMMENT '코드 문자값',
  `CODE_NUMBER_VALUE_ONE` int(11) DEFAULT NULL COMMENT '코드 문자값',
  `CODE_NUMBER_VALUE_TWO` int(11) DEFAULT NULL COMMENT '코드 문자값',
  `CODE_NUMBER_VALUE_TRREE` int(11) DEFAULT NULL COMMENT '코드 문자값',
  `CODE_NUMBER_VALUE_FROUR` int(11) DEFAULT NULL COMMENT '코드 문자값',
  `USE_YN` char(1) NOT NULL COMMENT '코드의 사용여부 \nY : 사용\nN : 미사용',
  `CREATE_DT` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CHANGE_DT` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`GROUP_CODE`,`DETAIL_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='공통코드 정보를 통합관리';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COM_CODE`
--

LOCK TABLES `COM_CODE` WRITE;
/*!40000 ALTER TABLE `COM_CODE` DISABLE KEYS */;
INSERT INTO `COM_CODE` VALUES ('CLUSTER_ACTION_ID','BI_DELETE',33,NULL,'Defline Action ID','Delete Built-in Service',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-05-30 00:32:22',NULL),('CLUSTER_ACTION_ID','BI_DEPLOY',31,NULL,'Defline Action ID','Deploy Built-in Service',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-05-30 00:32:22',NULL),('CLUSTER_ACTION_ID','BI_UPDATE',32,NULL,'Defline Action ID','Update Built-in Service',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-05-30 00:32:22',NULL),('CLUSTER_ACTION_ID','BI_UPDATE_CONF',34,NULL,'Defline Action ID','Update Built-in Service Configuration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-05-30 00:32:22',NULL),('CLUSTER_ACTION_ID','ES_CREATE',0,NULL,'Define Action ID','Create Cluster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:36:57',NULL),('CLUSTER_ACTION_ID','ES_DELETE',2,NULL,'Define Action ID','Delete Cluster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:36:57',NULL),('CLUSTER_ACTION_ID','ES_SCALE_IN',4,NULL,'Define Action ID','Scale in Cluster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:36:57',NULL),('CLUSTER_ACTION_ID','ES_SCALE_OUT',3,NULL,'Define Action ID','Scale out Cluster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:36:57',NULL),('CLUSTER_ACTION_ID','ES_START',5,NULL,'Define Action ID','Start Cluster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-04-24 08:43:36',NULL),('CLUSTER_ACTION_ID','ES_STOP',1,NULL,'Define Action ID','Stop Cluster',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:36:57',NULL),('CLUSTER_ACTION_ID','ES_UPDATE_CONF',6,NULL,'Define Action ID','Update ES Configuration',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:47:13',NULL),('CLUSTER_ACTION_ID','ES_UPDATE_DESC',7,NULL,'Define Action ID','Update ES Description',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-04-26 06:36:50',NULL),('CLUSTER_ACTION_ID','KIBANA_START',21,NULL,'Define Action ID','Start Kibana',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:36:57',NULL),('CLUSTER_ACTION_ID','KIBANA_STOP',22,NULL,'Define Action ID','Stop kibana',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:36:57',NULL),('ES_001','GREEN',0,NULL,'ES health 상태코드 관리','정상',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('ES_001','RED',2,NULL,'ES health 상태코드 관리','에러',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('ES_001','YELLO',1,NULL,'ES health 상태코드 관리','경고',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('ES_NODE_TYPE','D',1,NULL,'Elasticsearch Data Node','Data Node',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('ES_NODE_TYPE','K',2,NULL,'Kibana','Kibana',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:46',NULL),('ES_NODE_TYPE','M',0,NULL,'Elasticsearch Master Node','Master Node',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('NODE_ACTION_ID','NODE_ADD',0,NULL,'Define Action ID','Add Node',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-04-26 00:54:07',NULL),('NODE_ACTION_ID','NODE_DELETE',1,NULL,'Define Action ID','Delete Node',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2018-04-26 00:54:07',NULL),('RANCHER_INFO','API_PASS_KEY',8,NULL,'Rancher  정보','SPdGTa6JtLR5KTsDEeaSyRpLEQQXLpPzXbeFBuYo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('RANCHER_INFO','API_USER_KEY',0,NULL,'Rancher  정보','8EC0A7BA9B3659F5DF9B',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('RANCHER_INFO','IP',0,NULL,'Rancher  정보','169.56.72.230',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL),('RANCHER_INFO','PORT',0,NULL,'Rancher  정보','8080',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','2018-04-05 08:28:48',NULL);
/*!40000 ALTER TABLE `COM_CODE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ES_CLUSTER_HIST`
--

DROP TABLE IF EXISTS `ES_CLUSTER_HIST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ES_CLUSTER_HIST` (
  `CLUSTER_ID` int(11) NOT NULL,
  `ACTION_ID` varchar(30) DEFAULT NULL COMMENT '어떤 업데이트를 실행했는지\n공통코드에 정의\n01 : NODE_SCALE\n02 : Configuration update\n03 : STOP\n04 : START\n05 : RESTART',
  `ACTION_VALUE` varchar(5000) DEFAULT NULL COMMENT 'ACTION_ID에 따른 값\nACTION_ID가 \n01 (Node_SCALE) : 변경된 Node의 수\n02(Configuration update) : JSON 구조의 환경설정\n\n\n02인 경우 ACTION_VALUE의 값이\n- json 구조로  \n“curl -XPUT localhost:10300/_cluster/settings” 에 포함되는 \nbody를 입력\n화면 출력시 json을 파싱하거나, 그대로 보여준다.\n처음 es를 설치하면 default 설정으로 아무런 값이 조회되지 않음',
  `CREATE_DT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '업데이트를 실행한 일시',
  PRIMARY KEY (`CLUSTER_ID`,`CREATE_DT`),
  KEY `fk_ES_CLUSTER_HIST_ES_CLUSTER_LIST1_idx` (`CLUSTER_ID`),
  CONSTRAINT `fk_ES_CLUSTER_HIST_ES_CLUSTER_LIST1` FOREIGN KEY (`CLUSTER_ID`) REFERENCES `ES_CLUSTER_LIST` (`CLUSTER_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ES를 변경(Node 추가, 중지, 삭제 등)한 이력을 관리하는 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ES_CLUSTER_HIST`
--

LOCK TABLES `ES_CLUSTER_HIST` WRITE;
/*!40000 ALTER TABLE `ES_CLUSTER_HIST` DISABLE KEYS */;
/*!40000 ALTER TABLE `ES_CLUSTER_HIST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ES_CLUSTER_LIST`
--

DROP TABLE IF EXISTS `ES_CLUSTER_LIST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ES_CLUSTER_LIST` (
  `CLUSTER_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '<USER_ID>-ESC-001',
  `USER_ID` varchar(100) NOT NULL,
  `CLUSTER_NAME` varchar(50) DEFAULT NULL COMMENT '클러스터 명',
  `CLUSTER_TYPE_ID` char(2) NOT NULL,
  `RANCHER_PROJECT_ID` varchar(20) DEFAULT NULL,
  `RANCHER_STACK_ID` varchar(20) DEFAULT NULL COMMENT '\nES 클러스터가 배포된 Rancher의 stack id',
  `ENDPOINT_ES` varchar(200) DEFAULT NULL,
  `ENDPOINT_KIBANA` varchar(200) DEFAULT NULL,
  `NODE_SIZE` int(11) DEFAULT NULL COMMENT '초기  CLUSTER_TYPE에 정해진 숫자를 입력함.\n이후 scale out을 통해 증가한 경우 node_size 값이 변경됨.',
  `ES_CONFIG` varchar(5000) DEFAULT NULL COMMENT 'Elasticsearch 구동 이후에 사용자가 변경한 configuration \nES api를 이용하여 설정한 값',
  `STATUS` varchar(45) DEFAULT NULL COMMENT '01 : Docker 서비스 진행중\n02 : Docker 서비스 중지\n03 : Docker 서비스 삭제',
  `DESCRIPTION` varchar(1000) DEFAULT NULL COMMENT '클러스터에 대한 상세 설명',
  `USE_YN` char(1) DEFAULT 'Y' COMMENT 'Y : 클러스터 사용중\nN : 클러스터 삭제됨',
  `START_DT` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '서비스를 시작한 시간 (재시작 등)',
  `STOP_DT` timestamp NULL DEFAULT NULL COMMENT '클러스터를 중지한 시간',
  `CREATE_DT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '클러스터를 생성한 시간',
  `TOTAL_USAGE_TIME` bigint(20) DEFAULT '0',
  PRIMARY KEY (`CLUSTER_ID`),
  UNIQUE KEY `CLUSTER_ID_UNIQUE` (`CLUSTER_ID`),
  KEY `IX_01` (`USER_ID`),
  KEY `IX_02` (`USER_ID`,`CREATE_DT`),
  KEY `fk_ES_CLUSTER_LIST_ES_CLUSTER_TYPE1_idx` (`CLUSTER_TYPE_ID`),
  CONSTRAINT `fk_ES_CLUSTER_LIST_ES_CLUSTER_TYPE1` FOREIGN KEY (`CLUSTER_TYPE_ID`) REFERENCES `ES_CLUSTER_TYPE` (`CLUSTER_TYPE_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=870 DEFAULT CHARSET=utf8 COMMENT='사용자가 생성한 ES Cluster에 대한 메인 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ES_CLUSTER_LIST`
--

LOCK TABLES `ES_CLUSTER_LIST` WRITE;
/*!40000 ALTER TABLE `ES_CLUSTER_LIST` DISABLE KEYS */;
/*!40000 ALTER TABLE `ES_CLUSTER_LIST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ES_CLUSTER_NODE_LIST`
--

DROP TABLE IF EXISTS `ES_CLUSTER_NODE_LIST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ES_CLUSTER_NODE_LIST` (
  `NODE_ID` varchar(45) DEFAULT NULL COMMENT 'STACK_ID + SERVICE_ID + CONTAINER_ID\n서버에 장애가 발생하여, \ncontainer가 삭제되고 다시 생성되는 경우 container_id는 변경될 수 있음.',
  `ES_CLUSTER_LIST_CLUSTER_ID` int(11) NOT NULL,
  `ES_NODE_NAME` varchar(50) NOT NULL,
  `RANCHER_SERVICE_ID` varchar(20) NOT NULL COMMENT 'Rancher server에서 관리하는 service 고유값',
  `RANCHER_CONTAINER_ID` varchar(100) NOT NULL COMMENT 'Rancher server에서 관리하는 container 고유값\n(Container가 삭제되고 재구동시 id가 변경될 수 있음)\n(이를 감지하고, 업데이트 할 수 있는 방안 필요) -> quartz 스케줄러 활용 (안)',
  `IP` varchar(25) DEFAULT NULL COMMENT 'Container가 설치된 물리서버 IP',
  `GOTTY_PORT` varchar(5) DEFAULT NULL COMMENT 'web console 접속을 위한 외부 port',
  `NODE_TYPE` varchar(45) DEFAULT NULL COMMENT '3가지 타입이 존재\n- MASTER\n- DATA\n- KIBANA',
  `CREATE_DT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ES_CLUSTER_LIST_CLUSTER_ID`,`RANCHER_SERVICE_ID`),
  KEY `IX_01` (`NODE_ID`),
  KEY `fk_ES_CLUSTER_NODE_LIST_ES_CLUSTER_LIST1_idx` (`ES_CLUSTER_LIST_CLUSTER_ID`),
  CONSTRAINT `fk_ES_CLUSTER_NODE_LIST_ES_CLUSTER_LIST1` FOREIGN KEY (`ES_CLUSTER_LIST_CLUSTER_ID`) REFERENCES `ES_CLUSTER_LIST` (`CLUSTER_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Elasticsearch cluster에 포함된 node 목록을 관리한다 (master, data, kibana )';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ES_CLUSTER_NODE_LIST`
--

LOCK TABLES `ES_CLUSTER_NODE_LIST` WRITE;
/*!40000 ALTER TABLE `ES_CLUSTER_NODE_LIST` DISABLE KEYS */;
/*!40000 ALTER TABLE `ES_CLUSTER_NODE_LIST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ES_CLUSTER_TYPE`
--

DROP TABLE IF EXISTS `ES_CLUSTER_TYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ES_CLUSTER_TYPE` (
  `CLUSTER_TYPE_ID` char(2) NOT NULL COMMENT '\nC1 : Node 1, CPU 1 core, MEM 4G\nC2 : Node 3, CPU 2 core, MEM 8G\nC3 : Node 5, CPU 4 core, MEM 16G',
  `NODE_SIZE` varchar(45) NOT NULL COMMENT 'es 클러스터를 구성하는 \nMaster Node + Data Node의 개수\nKibana는 별도로 설치됨',
  `CPU_NUM` int(11) NOT NULL COMMENT 'CPU 개수 (core)\n1,000 = 1 core',
  `MEM` int(10) unsigned NOT NULL COMMENT 'Byte로 입력 (화면 출력시 MB로 변환)',
  `DISK` int(11) DEFAULT NULL COMMENT 'GB\n디스크 사이즈는 컨테이너별로 할당이 어려움.\n따라서 별도의 옵션을 사용할 수 없음 (삭제예정)',
  `DESC` varchar(1000) DEFAULT NULL COMMENT 'TYPE에 대한 설명',
  PRIMARY KEY (`CLUSTER_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사전에 정의된 Cluster type 정보를 관리한다.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ES_CLUSTER_TYPE`
--

LOCK TABLES `ES_CLUSTER_TYPE` WRITE;
/*!40000 ALTER TABLE `ES_CLUSTER_TYPE` DISABLE KEYS */;
INSERT INTO `ES_CLUSTER_TYPE` VALUES ('C1','1',1,4,300,'Light User 용'),('C2','2',2,6,600,'Middle User 용'),('C3','3',3,8,900,'Advanced User 용');
/*!40000 ALTER TABLE `ES_CLUSTER_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ES_CLUSTER_USAGE`
--

DROP TABLE IF EXISTS `ES_CLUSTER_USAGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ES_CLUSTER_USAGE` (
  `CLUSTER_ID` varchar(45) NOT NULL,
  `START_DT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `STOP_DT` timestamp NULL DEFAULT NULL,
  `USAGE_TIME` bigint(20) DEFAULT '0',
  PRIMARY KEY (`CLUSTER_ID`,`START_DT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ES_CLUSTER_USAGE`
--

LOCK TABLES `ES_CLUSTER_USAGE` WRITE;
/*!40000 ALTER TABLE `ES_CLUSTER_USAGE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ES_CLUSTER_USAGE` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-17 18:08:12
