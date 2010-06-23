-- MySQL dump 10.13  Distrib 5.1.42, for apple-darwin10.2.0 (i386)
--
-- Host: localhost    Database: ultima
-- ------------------------------------------------------
-- Server version	5.1.42

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
-- Table structure for table `bancos`
--

DROP TABLE IF EXISTS `bancos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bancos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `num_cuenta` varchar(255) DEFAULT NULL,
  `titular` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `colonia_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bancos`
--

LOCK TABLES `bancos` WRITE;
/*!40000 ALTER TABLE `bancos` DISABLE KEYS */;
/*!40000 ALTER TABLE `bancos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `civils`
--

DROP TABLE IF EXISTS `civils`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `civils` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `civil` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `civils`
--

LOCK TABLES `civils` WRITE;
/*!40000 ALTER TABLE `civils` DISABLE KEYS */;
INSERT INTO `civils` VALUES (1,'SOLTERO'),(2,'CASADO'),(3,'VIUDO'),(4,'DIVORCIADO');
/*!40000 ALTER TABLE `civils` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paterno` varchar(255) DEFAULT NULL,
  `materno` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `rfc` varchar(13) DEFAULT NULL,
  `curp` varchar(18) DEFAULT NULL,
  `clave_ife` varchar(255) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `nacionalidad` varchar(255) DEFAULT NULL,
  `tipo_propiedad` varchar(255) DEFAULT NULL,
  `tipo_persona` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `codigo_postal` varchar(255) DEFAULT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `civil_id` int(11) DEFAULT NULL,
  `escolaridad_id` int(11) DEFAULT NULL,
  `vivienda_id` int(11) DEFAULT NULL,
  `colonia_id` int(11) DEFAULT NULL,
  `grupo_id` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'monterrosa','lopez','carlos',NULL,'MOLC8509121S0','MOLC850912HCSNPR02','44444','M','MEXICANA','NUEVA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colonias`
--

DROP TABLE IF EXISTS `colonias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colonias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `colonia` varchar(255) DEFAULT NULL,
  `clave_inegi` varchar(255) DEFAULT NULL,
  `ejido_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colonias`
--

LOCK TABLES `colonias` WRITE;
/*!40000 ALTER TABLE `colonias` DISABLE KEYS */;
INSERT INTO `colonias` VALUES (1,'CENTRO',NULL,1),(2,'LA LOMITA',NULL,1),(3,'24 DE JUNIO',NULL,1),(4,'POTINASPAK',NULL,1),(5,'POMAROSA',NULL,1),(6,'COPOYA',NULL,2),(7,'LAURELES',NULL,3),(8,'CENTRO',NULL,3),(9,'VISTAHERMOSA',NULL,3),(10,'PLAYA LINDA',NULL,4);
/*!40000 ALTER TABLE `colonias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion`
--

DROP TABLE IF EXISTS `configuracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configuracion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tasa_interes` varchar(255) DEFAULT NULL,
  `interes_moratorio` varchar(255) DEFAULT NULL,
  `multa` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion`
--

LOCK TABLES `configuracion` WRITE;
/*!40000 ALTER TABLE `configuracion` DISABLE KEYS */;
INSERT INTO `configuracion` VALUES (1,'2.5','2.5','0');
/*!40000 ALTER TABLE `configuracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditos`
--

DROP TABLE IF EXISTS `creditos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creditos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `num_referencia` varchar(255) DEFAULT NULL,
  `monto` float DEFAULT NULL,
  `tasa_interes` float DEFAULT NULL,
  `interes_moratorio` varchar(255) DEFAULT NULL,
  `num_pagos` int(11) DEFAULT NULL,
  `linea_id` int(11) DEFAULT NULL,
  `banco_id` int(11) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `promotor_id` int(11) DEFAULT NULL,
  `destino_id` int(11) DEFAULT NULL,
  `grupo_id` int(11) DEFAULT NULL,
  `periodo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditos`
--

LOCK TABLES `creditos` WRITE;
/*!40000 ALTER TABLE `creditos` DISABLE KEYS */;
INSERT INTO `creditos` VALUES (1,'2010-06-09','2010-06-21','4484444',45000,NULL,NULL,10,NULL,NULL,NULL,1,NULL,1,1),(2,'2010-06-01','2010-06-24','4444',44,4,'34',3,1,4,5,5,3,0,1),(3,'2010-06-09','2010-06-12','844949849',35000,4,'4',3,4,NULL,NULL,1,NULL,1,1),(4,'2010-06-09','2010-06-12','844949849',35000,2.5,'4',3,4,NULL,NULL,1,NULL,1,1),(5,'2010-06-09','2010-06-12','844949849',35000,2.5,'2.5',3,NULL,NULL,NULL,1,NULL,1,1),(6,'2010-06-09','2010-06-12','844949849',35000,2.5,'2.5',3,NULL,NULL,NULL,1,NULL,1,1),(7,'2010-06-09','2010-06-14','344444',24000,2.5,'2.5',4,NULL,NULL,NULL,1,NULL,2,1),(8,'2010-06-09','2010-06-12','444',20000,2.5,'2.5',3,NULL,NULL,NULL,1,NULL,2,1),(9,'2010-06-08','2010-06-14','5454545',10000,2.5,'2.5',5,4,NULL,NULL,1,NULL,2,1),(10,'2010-06-08','2010-06-29','5555',1000,2.5,'2.5',3,4,NULL,NULL,1,NULL,2,2),(11,'2010-06-10','2010-06-16','5',555,2.5,'2.5',5,4,NULL,NULL,1,NULL,2,1),(12,'2010-06-01','2010-07-06','56654',1000,2.5,'2.5',5,4,NULL,NULL,1,NULL,2,2);
/*!40000 ALTER TABLE `creditos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `destinos`
--

DROP TABLE IF EXISTS `destinos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `destinos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `destino` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `destinos`
--

LOCK TABLES `destinos` WRITE;
/*!40000 ALTER TABLE `destinos` DISABLE KEYS */;
/*!40000 ALTER TABLE `destinos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ejidos`
--

DROP TABLE IF EXISTS `ejidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ejidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ejido` varchar(255) DEFAULT NULL,
  `clave_inegi` varchar(255) DEFAULT NULL,
  `municipio_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ejidos`
--

LOCK TABLES `ejidos` WRITE;
/*!40000 ALTER TABLE `ejidos` DISABLE KEYS */;
INSERT INTO `ejidos` VALUES (1,'TUXTLA GUTIERREZ',NULL,1),(2,'EL JOBO',NULL,1),(3,'LOS NARANJOS',NULL,2),(4,'LAS FLORES',NULL,2);
/*!40000 ALTER TABLE `ejidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `escolaridads`
--

DROP TABLE IF EXISTS `escolaridads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `escolaridads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `escolaridad` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `escolaridads`
--

LOCK TABLES `escolaridads` WRITE;
/*!40000 ALTER TABLE `escolaridads` DISABLE KEYS */;
INSERT INTO `escolaridads` VALUES (1,'NINGUNA'),(2,'PRIMARIA'),(3,'SECUNDARIA'),(4,'PREPARATORIA'),(5,'CARRERA TRUNCA'),(6,'LICENCIATURA'),(7,'POSGRADO');
/*!40000 ALTER TABLE `escolaridads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados`
--

DROP TABLE IF EXISTS `estados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estados` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `estado` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados`
--

LOCK TABLES `estados` WRITE;
/*!40000 ALTER TABLE `estados` DISABLE KEYS */;
INSERT INTO `estados` VALUES (1,'CHIAPAS'),(2,'AGUASCALIENTES'),(3,'BAJA CALIFORNIA'),(4,'CHIHUAHUA'),(5,'VERACRUZ'),(6,'TABASCO'),(7,'MORELOS'),(8,'ESTADO DE MEXICO'),(9,'JALISCO'),(10,'YUCATAN');
/*!40000 ALTER TABLE `estados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `festivos`
--

DROP TABLE IF EXISTS `festivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `festivos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` date DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `festivos`
--

LOCK TABLES `festivos` WRITE;
/*!40000 ALTER TABLE `festivos` DISABLE KEYS */;
INSERT INTO `festivos` VALUES (1,'2010-05-01','dia del trabajo');
/*!40000 ALTER TABLE `festivos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fondeos`
--

DROP TABLE IF EXISTS `fondeos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fondeos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fuente` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fondeos`
--

LOCK TABLES `fondeos` WRITE;
/*!40000 ALTER TABLE `fondeos` DISABLE KEYS */;
INSERT INTO `fondeos` VALUES (1,'SICCAR');
/*!40000 ALTER TABLE `fondeos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `garantias`
--

DROP TABLE IF EXISTS `garantias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `garantias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `garantia` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `garantias`
--

LOCK TABLES `garantias` WRITE;
/*!40000 ALTER TABLE `garantias` DISABLE KEYS */;
/*!40000 ALTER TABLE `garantias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `garantias_referencias`
--

DROP TABLE IF EXISTS `garantias_referencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `garantias_referencias` (
  `referencia_id` int(11) DEFAULT NULL,
  `garantia_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `garantias_referencias`
--

LOCK TABLES `garantias_referencias` WRITE;
/*!40000 ALTER TABLE `garantias_referencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `garantias_referencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `giros`
--

DROP TABLE IF EXISTS `giros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `giros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `giro` varchar(255) DEFAULT NULL,
  `codigo` varchar(255) DEFAULT NULL,
  `subsector` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giros`
--

LOCK TABLES `giros` WRITE;
/*!40000 ALTER TABLE `giros` DISABLE KEYS */;
/*!40000 ALTER TABLE `giros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grupos`
--

DROP TABLE IF EXISTS `grupos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grupos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grupos`
--

LOCK TABLES `grupos` WRITE;
/*!40000 ALTER TABLE `grupos` DISABLE KEYS */;
INSERT INTO `grupos` VALUES (1,'Ninguno'),(2,'VILLAFLORES');
/*!40000 ALTER TABLE `grupos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lineas`
--

DROP TABLE IF EXISTS `lineas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lineas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fondeo_id` int(11) DEFAULT NULL,
  `cuenta_cheques` varchar(255) DEFAULT NULL,
  `fecha_aut` date DEFAULT NULL,
  `autorizado` float DEFAULT NULL,
  `estatus` varchar(255) DEFAULT NULL,
  `gcnf` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lineas`
--

LOCK TABLES `lineas` WRITE;
/*!40000 ALTER TABLE `lineas` DISABLE KEYS */;
INSERT INTO `lineas` VALUES (4,1,'1111','2010-01-01',100000,'A','1');
/*!40000 ALTER TABLE `lineas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos`
--

DROP TABLE IF EXISTS `movimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movimientos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` varchar(255) DEFAULT NULL,
  `capital` float DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `interes` float DEFAULT NULL,
  `concepto` varchar(255) DEFAULT NULL,
  `pago_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos`
--

LOCK TABLES `movimientos` WRITE;
/*!40000 ALTER TABLE `movimientos` DISABLE KEYS */;
INSERT INTO `movimientos` VALUES (1,NULL,600,'2010-06-09',150,NULL,NULL),(2,NULL,6000,'2010-06-09',150,NULL,NULL);
/*!40000 ALTER TABLE `movimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `municipios`
--

DROP TABLE IF EXISTS `municipios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `municipios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `municipio` varchar(255) DEFAULT NULL,
  `clave_inegi` varchar(255) DEFAULT NULL,
  `estado_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `municipios`
--

LOCK TABLES `municipios` WRITE;
/*!40000 ALTER TABLE `municipios` DISABLE KEYS */;
INSERT INTO `municipios` VALUES (1,'TUXTLA GUTIERREZ',NULL,1),(2,'TAPACHULA',NULL,1),(3,'SAN CRISTOBAL DE LAS CASAS',NULL,1);
/*!40000 ALTER TABLE `municipios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `negocios`
--

DROP TABLE IF EXISTS `negocios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `negocios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `puesto` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `num_empleados` int(11) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `giro_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `negocios`
--

LOCK TABLES `negocios` WRITE;
/*!40000 ALTER TABLE `negocios` DISABLE KEYS */;
/*!40000 ALTER TABLE `negocios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num_pago` int(11) DEFAULT NULL,
  `fecha_limite` date DEFAULT NULL,
  `capital_minimo` varchar(255) DEFAULT NULL,
  `interes_minimo` varchar(255) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `capital` varchar(255) DEFAULT NULL,
  `interes` varchar(255) DEFAULT NULL,
  `moratorio` varchar(255) DEFAULT NULL,
  `pagado` int(11) DEFAULT NULL,
  `credito_id` int(11) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
INSERT INTO `pagos` VALUES (1,1,'2010-06-10','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,4,'Pago 1 de 3 capital minimo 11666.6666666667 '),(2,2,'2010-06-11','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,4,'Pago 2 de 3 capital minimo 11666.6666666667 '),(3,3,'2010-06-12','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,4,'Pago 3 de 3 capital minimo 11666.6666666667 '),(4,1,'2010-06-10','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,5,'Pago 1 de 3 capital minimo 11666.6666666667 '),(5,2,'2010-06-11','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,5,'Pago 2 de 3 capital minimo 11666.6666666667 '),(6,3,'2010-06-12','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,5,'Pago 3 de 3 capital minimo 11666.6666666667 '),(7,1,'2010-06-10','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,6,'Pago 1 de 3 capital minimo 11666.6666666667 '),(8,2,'2010-06-11','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,6,'Pago 2 de 3 capital minimo 11666.6666666667 '),(9,3,'2010-06-12','11666.6666666667','291.666666666667',NULL,NULL,NULL,NULL,0,6,'Pago 3 de 3 capital minimo 11666.6666666667 '),(10,1,'2010-06-09','6000.0','150.0','2010-06-10','6000','150','153.75',1,7,'Pago 1 de 4 capital minimo 6000.0 '),(11,2,'2010-06-11','6000.0','150.0','0000-00-00','6000','150','0',0,7,'Pago 2 de 4 capital minimo 6000.0 '),(12,3,'2010-06-12','6000.0','150.0','0000-00-00','6000','150',NULL,0,7,'Pago 3 de 4 capital minimo 6000.0 '),(13,4,'2010-06-14','6000.0','150.0','0000-00-00','6000','150',NULL,0,7,'Pago 4 de 4 capital minimo 6000.0 '),(14,1,'2010-06-10','6666.66666666667','166.666666666667',NULL,NULL,NULL,NULL,0,8,'Pago 1 de 3 capital minimo 6666.66666666667 '),(15,2,'2010-06-11','6666.66666666667','166.666666666667',NULL,NULL,NULL,NULL,0,8,'Pago 2 de 3 capital minimo 6666.66666666667 '),(16,3,'2010-06-12','6666.66666666667','166.666666666667',NULL,NULL,NULL,NULL,0,8,'Pago 3 de 3 capital minimo 6666.66666666667 '),(17,1,'2010-06-09','2000.0','50.0','2010-06-10','2000','50','51.25',1,9,'Pago 1 de 5 capital minimo 2000.0 '),(18,2,'2010-06-10','2000.0','50.0','2010-06-10','2000','50',NULL,1,9,'Pago 2 de 5 capital minimo 2000.0 '),(19,3,'2010-06-11','2000.0','50.0',NULL,NULL,NULL,NULL,0,9,'Pago 3 de 5 capital minimo 2000.0 '),(20,4,'2010-06-12','2000.0','50.0',NULL,NULL,NULL,NULL,0,9,'Pago 4 de 5 capital minimo 2000.0 '),(21,5,'2010-06-14','2000.0','50.0',NULL,NULL,NULL,NULL,0,9,'Pago 5 de 5 capital minimo 2000.0 '),(22,1,'2010-06-15','333.333333333333','8.33333333333333','2010-06-10','333','9',NULL,1,10,'Pago 1 de 3 capital minimo 333.333333333333 '),(23,2,'2010-06-22','333.333333333333','8.33333333333333',NULL,NULL,NULL,NULL,0,10,'Pago 2 de 3 capital minimo 333.333333333333 '),(24,3,'2010-06-29','333.333333333333','8.33333333333333',NULL,NULL,NULL,NULL,0,10,'Pago 3 de 3 capital minimo 333.333333333333 '),(25,1,'2010-06-11','111.0','2.775',NULL,NULL,NULL,NULL,0,11,'Pago 1 de 5 capital minimo 111.0 '),(26,2,'2010-06-12','111.0','2.775',NULL,NULL,NULL,NULL,0,11,'Pago 2 de 5 capital minimo 111.0 '),(27,3,'2010-06-14','111.0','2.775',NULL,NULL,NULL,NULL,0,11,'Pago 3 de 5 capital minimo 111.0 '),(28,4,'2010-06-15','111.0','2.775',NULL,NULL,NULL,NULL,0,11,'Pago 4 de 5 capital minimo 111.0 '),(29,5,'2010-06-16','111.0','2.775',NULL,NULL,NULL,NULL,0,11,'Pago 5 de 5 capital minimo 111.0 '),(30,1,'2010-06-08','200.0','5.0','2010-06-10','200','11','5.125',1,12,'Pago 1 de 5 capital minimo 200.0 '),(31,2,'2010-06-15','200.0','5.0',NULL,NULL,NULL,NULL,0,12,'Pago 2 de 5 capital minimo 200.0 '),(32,3,'2010-06-22','200.0','5.0',NULL,NULL,NULL,NULL,0,12,'Pago 3 de 5 capital minimo 200.0 '),(33,4,'2010-06-29','200.0','5.0',NULL,NULL,NULL,NULL,0,12,'Pago 4 de 5 capital minimo 200.0 '),(34,5,'2010-07-06','200.0','5.0',NULL,NULL,NULL,NULL,0,12,'Pago 5 de 5 capital minimo 200.0 ');
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagoslineas`
--

DROP TABLE IF EXISTS `pagoslineas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagoslineas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `linea_id` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `monto` varchar(255) DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagoslineas`
--

LOCK TABLES `pagoslineas` WRITE;
/*!40000 ALTER TABLE `pagoslineas` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagoslineas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `periodos`
--

DROP TABLE IF EXISTS `periodos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `periodos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `dias` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periodos`
--

LOCK TABLES `periodos` WRITE;
/*!40000 ALTER TABLE `periodos` DISABLE KEYS */;
INSERT INTO `periodos` VALUES (1,'Dia',1),(2,'Semana',7),(3,'Quincena',15),(4,'Mes',30),(5,'Bimestre',60),(6,'Semestre',180),(7,'AÃ±o',365);
/*!40000 ALTER TABLE `periodos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producto` varchar(255) DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `intereses` float DEFAULT NULL,
  `iva_intereses` float DEFAULT NULL,
  `moratorio` float DEFAULT NULL,
  `multa` float DEFAULT NULL,
  `iva_multa` float DEFAULT NULL,
  `garantia` varchar(255) DEFAULT NULL,
  `periodo_id` int(11) DEFAULT NULL,
  `grupo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotors`
--

DROP TABLE IF EXISTS `promotors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promotors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paterno` varchar(255) DEFAULT NULL,
  `materno` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `celular` varchar(10) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotors`
--

LOCK TABLES `promotors` WRITE;
/*!40000 ALTER TABLE `promotors` DISABLE KEYS */;
INSERT INTO `promotors` VALUES (1,'MONTOYA','ROBLES','RAMIRO','CALZADA JUAN E','9872723','839839','cmonterrosa@coreeo.com',NULL);
/*!40000 ALTER TABLE `promotors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referencias`
--

DROP TABLE IF EXISTS `referencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `referencias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paterno` varchar(255) DEFAULT NULL,
  `materno` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `parentesco` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `credito_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referencias`
--

LOCK TABLES `referencias` WRITE;
/*!40000 ALTER TABLE `referencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `referencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rols`
--

DROP TABLE IF EXISTS `rols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rols`
--

LOCK TABLES `rols` WRITE;
/*!40000 ALTER TABLE `rols` DISABLE KEYS */;
INSERT INTO `rols` VALUES (1,'clientes'),(2,'capturistas'),(3,'promotores'),(4,'gerentes'),(5,'administradores');
/*!40000 ALTER TABLE `rols` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_info` (
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_info`
--

LOCK TABLES `schema_info` WRITE;
/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
INSERT INTO `schema_info` VALUES (33);
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sectors`
--

DROP TABLE IF EXISTS `sectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sector` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sectors`
--

LOCK TABLES `sectors` WRITE;
/*!40000 ALTER TABLE `sectors` DISABLE KEYS */;
/*!40000 ALTER TABLE `sectors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `statu` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,'ACTIVA'),(2,'SUSPENDIDA'),(3,'CANCELADA');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subsectors`
--

DROP TABLE IF EXISTS `subsectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subsectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subsector` varchar(255) DEFAULT NULL,
  `sector_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subsectors`
--

LOCK TABLES `subsectors` WRITE;
/*!40000 ALTER TABLE `subsectors` DISABLE KEYS */;
/*!40000 ALTER TABLE `subsectors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sucursals`
--

DROP TABLE IF EXISTS `sucursals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sucursals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `gerente` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `codigo_postal` varchar(255) DEFAULT NULL,
  `colonia_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursals`
--

LOCK TABLES `sucursals` WRITE;
/*!40000 ALTER TABLE `sucursals` DISABLE KEYS */;
/*!40000 ALTER TABLE `sucursals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `systables`
--

DROP TABLE IF EXISTS `systables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `systables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controller` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `insertar` int(11) DEFAULT NULL,
  `eliminar` int(11) DEFAULT NULL,
  `actualizar` int(11) DEFAULT NULL,
  `consultar` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `systables`
--

LOCK TABLES `systables` WRITE;
/*!40000 ALTER TABLE `systables` DISABLE KEYS */;
INSERT INTO `systables` VALUES (1,'account','Acceso a Usuarios',1,1,0,1,NULL),(2,'account','Acceso a Usuarios',2,1,0,1,NULL),(3,'account','Acceso a Usuarios',3,1,0,1,NULL),(4,'account','Acceso a Usuarios',4,1,0,1,NULL),(5,'account','Acceso a Usuarios',5,1,0,1,NULL),(6,'fondeos','fondeos',2,1,0,1,NULL),(7,'fondeos','fondeos',5,1,0,1,NULL);
/*!40000 ALTER TABLE `systables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `rol_id` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'administrador','db9c93f05d2e41dc2256c3890d5d78ca6e48d418','administrador del sistema',5),(2,'monterrosa','db9c93f05d2e41dc2256c3890d5d78ca6e48d418','capturista de prueba',2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viviendas`
--

DROP TABLE IF EXISTS `viviendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viviendas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_vivienda` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viviendas`
--

LOCK TABLES `viviendas` WRITE;
/*!40000 ALTER TABLE `viviendas` DISABLE KEYS */;
/*!40000 ALTER TABLE `viviendas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-06-22 10:23:30