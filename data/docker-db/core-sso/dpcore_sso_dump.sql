-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: stg02    Database: dpcore_sso
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.36-MariaDB

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
-- Table structure for table `oauth_client_details`
--

DROP TABLE IF EXISTS `oauth_client_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_client_details` (
  `client_id` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `resource_ids` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_secret` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authorized_grant_types` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `web_server_redirect_uri` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authorities` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `access_token_validity` int(11) DEFAULT NULL,
  `refresh_token_validity` int(11) DEFAULT NULL,
  `additional_information` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL,
  `autoapprove` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_client_details`
--

LOCK TABLES `oauth_client_details` WRITE;
/*!40000 ALTER TABLE `oauth_client_details` DISABLE KEYS */;
INSERT INTO `oauth_client_details` VALUES ('admin',NULL,'ac9689e2272427085e35b9d3e3e8bed88cb3434828b43b86fc0596cad4c6e270','sso:admin','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',1800,0,NULL,'true'),('bigdata_poc',NULL,'8D27CE5DD1A4DA5BDEB1B6EA265EA8607E3AB33C1F55946292A44D294E967AE7','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('bigdata_poc01',NULL,'7B34B346718FA8CC19F7F416A3958571C5C3609E39F4760476703A69DD7A50E9','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('bigdata_poc02',NULL,'7C2F704886BD6AC3A45677CA18FCBD3DB1E73ECAF13D7B266E15510AAC994C1D','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('bigdata_poc03',NULL,'A513C86C7564B33CC3C7BF668E314C80AB739087B495CD9BAFA6D8DA3BC37A4E','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('bigdata_poc04',NULL,'47A4B9BA9A0CF765B325CB8B65683F11C4619F7805E7F31E2F302B85C41AA56B','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('bigdata_poc05',NULL,'7212ED0CEEFAC8829551A56B2C6419F668FA17AB7A2AA5742139818E4D4B40DE','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('bigdata_poc06',NULL,'EAF1036A235175135CC0DC54EEF5A2885DA679C117CCDBFBB2F7B72D0935B32D','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('C000094admin',NULL,'E2A846EE080DE33319517A0358BE348F60F961576982AB868D3977DE65D1E9B7','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('ds01',NULL,'3313AA7EA02D3A20ABB23A97F5B7C6E38892895AD43684ED22B83F367DA9A496','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('ds02',NULL,'6419F6B9B321453A2CF8287F41CB08E0090C5176CB14F96D04848EF300627B22','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('info-sec',NULL,'A8ACC6B6B82A323377D18E89C2C9CDDD3B16919D2C3E5ED04334E655E9EEDC04','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true'),('ISV001',NULL,'195184822304806801ADFAA8A1DAD19B0D09442CA630219A7D2A43D844FD4AB5','core:all','authorization_code,password,client_credentials,implicit,refresh_token',NULL,'ROLE_MY_CLIENT',86400,2592000,NULL,'true');
/*!40000 ALTER TABLE `oauth_client_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scope`
--

DROP TABLE IF EXISTS `scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scope` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `category` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `role` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `detail_role` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scope`
--

LOCK TABLES `scope` WRITE;
/*!40000 ALTER TABLE `scope` DISABLE KEYS */;
INSERT INTO `scope` VALUES (1,'sso','admin',NULL,'전체 회원에 대한 관리 권한'),(2,'core','all',NULL,'모든 모듈의 API를 사용 가능'),(3,'core','admin',NULL,'모든 사용자 정보에 대한 접근 권한'),(4,'cloudsearch','all',NULL,'cloudsearch user'),(5,'cloudsearch','admin',NULL,'cloudsearch admin 계정');
/*!40000 ALTER TABLE `scope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `user_name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `user_group` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'default',
  `password` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `scope` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('admin','SSO관리자','admin','ac9689e2272427085e35b9d3e3e8bed88cb3434828b43b86fc0596cad4c6e270','sso:admin'),('bigdata_poc','bigdata_poc','bigdata_poc','8D27CE5DD1A4DA5BDEB1B6EA265EA8607E3AB33C1F55946292A44D294E967AE7','core:all'),('bigdata_poc01','bigdata_poc01','bigdata_poc01','7B34B346718FA8CC19F7F416A3958571C5C3609E39F4760476703A69DD7A50E9','core:all'),('bigdata_poc02','bigdata_poc02','bigdata_poc02','7C2F704886BD6AC3A45677CA18FCBD3DB1E73ECAF13D7B266E15510AAC994C1D','core:all'),('bigdata_poc03','bigdata_poc03','bigdata_poc03','A513C86C7564B33CC3C7BF668E314C80AB739087B495CD9BAFA6D8DA3BC37A4E','core:all'),('bigdata_poc04','bigdata_poc04','bigdata_poc04','47A4B9BA9A0CF765B325CB8B65683F11C4619F7805E7F31E2F302B85C41AA56B','core:all'),('bigdata_poc05','bigdata_poc05','bigdata_poc05','7212ED0CEEFAC8829551A56B2C6419F668FA17AB7A2AA5742139818E4D4B40DE','core:all'),('bigdata_poc06','bigdata_poc06','bigdata_poc06','EAF1036A235175135CC0DC54EEF5A2885DA679C117CCDBFBB2F7B72D0935B32D','core:all'),('C000094admin','C000094admin','C000094admin','E2A846EE080DE33319517A0358BE348F60F961576982AB868D3977DE65D1E9B7','core:all'),('ds01','ds01','ds01','3313AA7EA02D3A20ABB23A97F5B7C6E38892895AD43684ED22B83F367DA9A496','core:all'),('ds02','ds02','ds02','6419F6B9B321453A2CF8287F41CB08E0090C5176CB14F96D04848EF300627B22','core:all'),('info-sec','info-sec','info-sec','A8ACC6B6B82A323377D18E89C2C9CDDD3B16919D2C3E5ED04334E655E9EEDC04','core:all'),('ISV001','ISV001','ISV001','195184822304806801ADFAA8A1DAD19B0D09442CA630219A7D2A43D844FD4AB5','core:all');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-11-27 14:54:38
