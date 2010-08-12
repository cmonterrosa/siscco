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
-- Table structure for table `ahorros`
--

DROP TABLE IF EXISTS `ahorros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ahorros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `monto` varchar(255) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `credito_id` int(11) DEFAULT NULL,
  `hora_fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ahorros`
--

LOCK TABLES `ahorros` WRITE;
/*!40000 ALTER TABLE `ahorros` DISABLE KEYS */;
/*!40000 ALTER TABLE `ahorros` ENABLE KEYS */;
UNLOCK TABLES;

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
  `municipio_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bancos`
--

LOCK TABLES `bancos` WRITE;
/*!40000 ALTER TABLE `bancos` DISABLE KEYS */;
INSERT INTO `bancos` VALUES (4,'BANORTE','9999','LIC. MENDEZ','9999999','999999',6),(5,'BANAMEX','7878','LIC. DOMINGUEZ PARRA','7373737','87373',13);
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
  `nacionalidad_id` int(11) DEFAULT NULL,
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (5,'MONTERROSA','LOPEZ','CARLOS','2010-07-26','MOLC8509121S0','MOLC850912HCSNPR02','XX','M',1,'PRIVADA','FISICA','X','9','9','9',1,1,1,10,0),(6,'HERNANDEZ','ESCOBAR','RAFAEL','2010-07-26','XXXXXXXXXX','XXXXXXXXXXXXXXXXXX','CCCCC','M',1,'PRIVADA','FISICA','xxxxxXX','9','0','0',1,3,1,10,0),(7,'DEL CARPIO','MENDEZ','OSCAR','2010-07-26','cccccccccccc9','cccccccccccccccccc','iiiiii','M',1,'PRIVADA','FISICA','iiii','0999','9','9',1,1,1,10,1),(8,'PEREZ','FUENTES','ITZEL','2010-07-26','PPPPPPPPPPPP','PPPPPPPPPPPPPPPPP5','OPOPOPOP','M',1,'PRIVADA','FISICA CON ACTIVIDAD EMPRESARIAL','OOOO','9999','4555','XXXXXX',1,6,1,10,1);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes_grupos`
--

DROP TABLE IF EXISTS `clientes_grupos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clientes_grupos` (
  `cliente_id` int(11) DEFAULT NULL,
  `grupo_id` int(11) DEFAULT NULL,
  `activo` int(11) DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_clientes_grupos_on_cliente_id` (`cliente_id`),
  KEY `index_clientes_grupos_on_grupo_id` (`grupo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes_grupos`
--

LOCK TABLES `clientes_grupos` WRITE;
/*!40000 ALTER TABLE `clientes_grupos` DISABLE KEYS */;
INSERT INTO `clientes_grupos` VALUES (7,2,0,'2010-08-05 20:38:29','2010-08-05 20:38:51',1),(7,2,1,'2010-08-05 20:39:15',NULL,2),(8,3,0,'2010-08-05 20:58:40','2010-08-09 20:36:08',3),(6,3,0,'2010-08-05 21:00:08','2010-08-09 20:36:16',4),(5,3,0,'2010-08-05 21:00:16','2010-08-09 20:36:13',5),(6,2,1,'2010-08-09 20:36:24',NULL,6),(5,2,0,'2010-08-09 20:36:27',NULL,7),(8,3,0,'2010-08-12 13:55:11','2010-08-12 13:55:41',8),(5,3,0,'2010-08-12 13:55:18','2010-08-12 13:55:35',9);
/*!40000 ALTER TABLE `clientes_grupos` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colonias`
--

LOCK TABLES `colonias` WRITE;
/*!40000 ALTER TABLE `colonias` DISABLE KEYS */;
INSERT INTO `colonias` VALUES (11,'CENTRO','XXXX',7),(12,'EL JOBO','XXXX',8),(13,'PLAN DE AYALA','XXXX',6);
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
  `nombre_empresa` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `activo` varchar(255) DEFAULT '1',
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion`
--

LOCK TABLES `configuracion` WRITE;
/*!40000 ALTER TABLE `configuracion` DISABLE KEYS */;
INSERT INTO `configuracion` VALUES (1,'SOCAMA FRAYLESCA S.A DE C.V',NULL,NULL,'1',NULL);
/*!40000 ALTER TABLE `configuracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controllers`
--

DROP TABLE IF EXISTS `controllers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `controllers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controller` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `controllers`
--

LOCK TABLES `controllers` WRITE;
/*!40000 ALTER TABLE `controllers` DISABLE KEYS */;
INSERT INTO `controllers` VALUES (1,'account','Autenticacion'),(2,'administracion','Administracion'),(3,'bancos','Bancos'),(4,'catalogos','Catalogos'),(5,'clientes','Clientes'),(6,'colonias','Colonias'),(7,'creditos','Creditos'),(8,'festivos','Dias Festivos'),(9,'lineas','Lineas de Fondeo'),(10,'pagos','Pagos'),(11,'pagoslineas','Pagos a Lineas de Fondeo');
/*!40000 ALTER TABLE `controllers` ENABLE KEYS */;
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
  `linea_id` int(11) DEFAULT NULL,
  `banco_id` int(11) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `promotor_id` int(11) DEFAULT NULL,
  `destino_id` int(11) DEFAULT NULL,
  `grupo_id` int(11) DEFAULT NULL,
  `producto_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditos`
--

LOCK TABLES `creditos` WRITE;
/*!40000 ALTER TABLE `creditos` DISABLE KEYS */;
INSERT INTO `creditos` VALUES (1,'2010-08-11',NULL,'3333',20000,2.5,'2.5',2,4,NULL,1,2,2,1,0,0),(2,'2010-08-11',NULL,'3333',20000,2.5,'2.5',1,4,NULL,1,2,2,1,0,0);
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
  `user_id` int(11) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `destinos`
--

LOCK TABLES `destinos` WRITE;
/*!40000 ALTER TABLE `destinos` DISABLE KEYS */;
INSERT INTO `destinos` VALUES (1,'CAPITAL DE NEGOCIO',NULL,NULL),(2,'PAGO DE DEUDA',NULL,NULL);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ejidos`
--

LOCK TABLES `ejidos` WRITE;
/*!40000 ALTER TABLE `ejidos` DISABLE KEYS */;
INSERT INTO `ejidos` VALUES (6,'PLAN DE AYALA','XXX',112,NULL),(7,'TUXTLA GUTIERREZ','XXXXX',112,NULL),(8,'EL JOBO','XXXXX',112,NULL),(9,'COPOYA','XXXXX',112,NULL);
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
  `edo_inegi` varchar(255) DEFAULT NULL,
  `edo_renapo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados`
--

LOCK TABLES `estados` WRITE;
/*!40000 ALTER TABLE `estados` DISABLE KEYS */;
INSERT INTO `estados` VALUES (44,'NACIONALIDAD EXTRANJERA','NE','NE\n'),(45,'AGUASCALIENTES','AGS','AS\n'),(46,'BAJA CALIFORNIA','BC','BC\n'),(47,'BAJA CALIFORNIA SUR','BCS','BS\n'),(48,'CAMPECHE','CAM','CC\n'),(49,'COAHUILA','COA','CL\n'),(50,'COLIMA','COL','CM\n'),(51,'CHIAPAS','CHS','CS\n'),(52,'CHIHUAHUA','CHI','CH\n'),(53,'DISTRITO FEDERAL','DF','DF\n'),(54,'DURANGO','DGO','DG\n'),(55,'GUANAJUATO','GTO','GT\n'),(56,'GUERRERO','GRO','GR\n'),(57,'HIDALGO','HGO','HG\n'),(58,'JALISCO','JAL','JC\n'),(59,'MEXICO','MEX','MC\n'),(60,'MICHOACAN','MIC','MN\n'),(61,'MORELOS','MOR','MS\n'),(62,'NAYARIT','NAY','NT\n'),(63,'NUEVO LEON','NL','NL\n'),(64,'OAXACA','OAX','OC\n'),(65,'PUEBLA','PUE','PL\n'),(66,'QUERETARO','QRO','QT\n'),(67,'QUINTANA ROO','Q ROO','QR\n'),(68,'SAN LUIS POTOSI','SLP','SP\n'),(69,'SINALOA','SIN','SL\n'),(70,'SONORA','SON','SR\n'),(71,'TABASCO','TAB','TC\n'),(72,'TAMAULIPAS','TAM','TS\n'),(73,'TLAXCALA','TLA','TL\n'),(74,'VERACRUZ','VER','VZ\n'),(75,'YUCATAN','YUC','YN\n'),(76,'ZACATECAS','ZAC','ZS\n');
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
INSERT INTO `fondeos` VALUES (1,'FOMMUR');
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giros`
--

LOCK TABLES `giros` WRITE;
/*!40000 ALTER TABLE `giros` DISABLE KEYS */;
INSERT INTO `giros` VALUES (1,'primario','78787','RECOLECCION',NULL);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grupos`
--

LOCK TABLES `grupos` WRITE;
/*!40000 ALTER TABLE `grupos` DISABLE KEYS */;
INSERT INTO `grupos` VALUES (2,'LOS GIRASOLES',NULL),(3,'LOS PETATES',NULL);
/*!40000 ALTER TABLE `grupos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jerarquias`
--

DROP TABLE IF EXISTS `jerarquias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jerarquias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jerarquia` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jerarquias`
--

LOCK TABLES `jerarquias` WRITE;
/*!40000 ALTER TABLE `jerarquias` DISABLE KEYS */;
/*!40000 ALTER TABLE `jerarquias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lineas`
--

DROP TABLE IF EXISTS `lineas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lineas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cuenta_cheques` varchar(255) DEFAULT NULL,
  `fecha_aut` date DEFAULT NULL,
  `autorizado` float DEFAULT NULL,
  `estatus` varchar(255) DEFAULT NULL,
  `gcnf` varchar(255) DEFAULT NULL,
  `fondeo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lineas`
--

LOCK TABLES `lineas` WRITE;
/*!40000 ALTER TABLE `lineas` DISABLE KEYS */;
INSERT INTO `lineas` VALUES (1,'99999999','2010-07-26',300000,'ACTIVA','A',1),(2,'893893893893','2010-08-02',230000,'ACTIVA',NULL,1);
/*!40000 ALTER TABLE `lineas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operacion` varchar(255) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `clase` varchar(255) DEFAULT NULL,
  `st` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `objeto_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,'INSERTAR','2010-07-26 22:15:03','Banco',NULL,1,3),(2,'INSERTAR','2010-07-26 22:16:35','Banco',NULL,1,4),(3,'ACTUALIZAR','2010-08-11 12:27:29','Banco',NULL,1,4),(4,'INSERTAR','2010-08-11 14:42:34','Credito',NULL,1,1),(5,'INSERTAR','2010-08-11 14:43:44','Credito',NULL,1,2);
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `miembros`
--

DROP TABLE IF EXISTS `miembros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `miembros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `credito_id` int(11) DEFAULT NULL,
  `jerarquia_id` int(11) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `miembros`
--

LOCK TABLES `miembros` WRITE;
/*!40000 ALTER TABLE `miembros` DISABLE KEYS */;
INSERT INTO `miembros` VALUES (1,1,NULL,7),(2,1,NULL,6),(3,1,NULL,5),(4,2,NULL,0),(5,2,NULL,7),(6,2,NULL,5);
/*!40000 ALTER TABLE `miembros` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos`
--

LOCK TABLES `movimientos` WRITE;
/*!40000 ALTER TABLE `movimientos` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=830 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `municipios`
--

LOCK TABLES `municipios` WRITE;
/*!40000 ALTER TABLE `municipios` DISABLE KEYS */;
INSERT INTO `municipios` VALUES (4,'ACACOYAGUA\n','07001',51),(5,'ACALA\n','07002',51),(6,'ACAPETAHUA\n','07003',51),(7,'ALDAMA\n','07113',51),(8,'ALTAMIRANO\n','07004',51),(9,'AMATAN\n','07005',51),(10,'AMATENANGO DE LA FRONTERA\n','07006',51),(11,'AMATENANGO DEL VALLE\n','07007',51),(12,'ANGEL ALBINO CORZO\n','07008',51),(13,'ARRIAGA\n','07009',51),(14,'BEJUCAL DE OCAMPO\n','07010',51),(15,'BELLA VISTA\n','07011',51),(16,'BENEMERITO DE LAS AMERICAS\n','07114',51),(17,'BERRIOZABAL\n','07012',51),(18,'BOCHIL\n','07013',51),(19,'CACAHOATAN\n','07015',51),(20,'CATAZAJA\n','07016',51),(21,'CINTALAPA\n','07017',51),(22,'COAPILLA\n','07018',51),(23,'COMITAN DE DOMINGUEZ\n','07019',51),(24,'COPAINALA\n','07021',51),(25,'CHALCHIHUITAN\n','07022',51),(26,'CHAMULA\n','07023',51),(27,'CHANAL\n','07024',51),(28,'CHAPULTENANGO\n','07025',51),(29,'CHENALHO\n','07026',51),(30,'CHIAPA DE CORZO\n','07027',51),(31,'CHIAPILLA\n','07028',51),(32,'CHICOASEN\n','07029',51),(33,'CHICOMUSELO\n','07030',51),(34,'CHILON\n','07031',51),(35,'EL BOSQUE\n','07014',51),(36,'EL PORVENIR\n','07070',51),(37,'ESCUINTLA\n','07032',51),(38,'FRANCISCO LEON\n','07033',51),(39,'FRONTERA COMALAPA\n','07034',51),(40,'FRONTERA HIDALGO\n','07035',51),(41,'HUEHUETAN\n','07037',51),(42,'HUITIUPAN\n','07039',51),(43,'HUIXTAN\n','07038',51),(44,'HUIXTLA\n','07040',51),(45,'IXHUATAN\n','07042',51),(46,'IXTACOMITAN\n','07043',51),(47,'IXTAPA\n','07044',51),(48,'IXTAPANGAJOYA\n','07045',51),(49,'JIQUIPILAS\n','07046',51),(50,'JITOTOL\n','07047',51),(51,'JUAREZ\n','07048',51),(52,'LA CONCORDIA\n','07020',51),(53,'LA GRANDEZA\n','07036',51),(54,'LA INDEPENDENCIA\n','07041',51),(55,'LA LIBERTAD\n','07050',51),(56,'LA TRINITARIA\n','07099',51),(57,'LARRAINZAR\n','07049',51),(58,'LAS MARGARITAS\n','07052',51),(59,'LAS ROSAS\n','07075',51),(60,'MAPASTEPEC\n','07051',51),(61,'MARAVILLA TENEJAPA\n','07115',51),(62,'MARQUES DE COMILLAS\n','07116',51),(63,'MAZAPA DE MADERO\n','07053',51),(64,'MAZATAN\n','07054',51),(65,'METAPA\n','07055',51),(66,'MITONTIC\n','07056',51),(67,'MONTECRISTO DE GUERRERO\n','07117',51),(68,'MOTOZINTLA\n','07057',51),(69,'NICOLAS RUIZ\n','07058',51),(70,'OCOSINGO\n','07059',51),(71,'OCOTEPEC\n','07060',51),(72,'OCOZOCOAUTLA DE ESPINOSA\n','07061',51),(73,'OSTUACAN\n','07062',51),(74,'OSUMACINTA\n','07063',51),(75,'OXCHUC\n','07064',51),(76,'PALENQUE\n','07065',51),(77,'PANTELHO\n','07066',51),(78,'PANTEPEC\n','07067',51),(79,'PICHUCALCO\n','07068',51),(80,'PIJIJIAPAN\n','07069',51),(81,'PUEBLO NUEVO SOLISTAHUACAN\n','07072',51),(82,'RAYON\n','07073',51),(83,'REFORMA\n','07074',51),(84,'SABANILLA\n','07076',51),(85,'SALTO DE AGUA\n','07077',51),(86,'SAN ANDRES DURAZNAL\n','07118',51),(87,'SAN CRISTOBAL DE LAS CASAS\n','07078',51),(88,'SAN FERNANDO\n','07079',51),(89,'SAN JUAN CANCUC\n','07112',51),(90,'SAN LUCAS\n','07110',51),(91,'SANTIAGO EL PINAR\n','07119',51),(92,'SILTEPEC\n','07080',51),(93,'SIMOJOVEL\n','07081',51),(94,'SITALA\n','07082',51),(95,'SOCOLTENANGO\n','07083',51),(96,'SOLOSUCHIAPA\n','07084',51),(97,'SOYALO\n','07085',51),(98,'SUCHIAPA\n','07086',51),(99,'SUCHIATE\n','07087',51),(100,'SUNUAPA\n','07088',51),(101,'TAPACHULA\n','07089',51),(102,'TAPALAPA\n','07090',51),(103,'TAPILULA\n','07091',51),(104,'TECPATAN\n','07092',51),(105,'TENEJAPA\n','07093',51),(106,'TEOPISCA\n','07094',51),(107,'TILA\n','07096',51),(108,'TONALA\n','07097',51),(109,'TOTOLAPA\n','07098',51),(110,'TUMBALA\n','07100',51),(111,'TUXTLA CHICO\n','07102',51),(112,'TUXTLA GUTIERREZ\n','07101',51),(113,'TUZANTAN\n','07103',51),(114,'TZIMOL\n','07104',51),(115,'UNION JUAREZ\n','07105',51),(116,'VENUSTIANO CARRANZA\n','07106',51),(117,'VILLA COMALTITLAN\n','07071',51),(118,'VILLA CORZO\n','07107',51),(119,'VILLAFLORES\n','07108',51),(120,'YAJALON\n','07109',51),(121,'ZINACANTAN\n','07111',51);
/*!40000 ALTER TABLE `municipios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nacionalidads`
--

DROP TABLE IF EXISTS `nacionalidads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nacionalidads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pais_id` varchar(255) DEFAULT NULL,
  `pais` varchar(255) DEFAULT NULL,
  `pais_gent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nacionalidads`
--

LOCK TABLES `nacionalidads` WRITE;
/*!40000 ALTER TABLE `nacionalidads` DISABLE KEYS */;
INSERT INTO `nacionalidads` VALUES (1,'AFG','AFGANISTAN','AFGANO\n'),(2,'ALB','ALBANIA','ALBANES\n'),(3,'DEU','ALEMANIA','ALEMAN\n'),(4,'AND','ANDORRA','ANDORRANO\n'),(5,'AGO','ANGOLA','ANGOLEÃ‘O\n'),(6,'AIA','ANGUILA','BRITANICO\n'),(7,'ATA','ANTARTICA','BRITANICO, FRANCES O AUSTRALIANO\n'),(8,'ATG','ANTIGUA Y BARBUDA','DE ANTIGUA Y BARBUDA\n'),(9,'ANT','ANTILLAS NEERLANDESAS','NEERLANDES\n'),(10,'SAU','ARABIA SAUDITA','ARABE SAUDITA\n'),(11,'DZA','ARGELIA','ARGELINO\n'),(12,'ARG','ARGENTINA','ARGENTINO\n'),(13,'ARM','ARMENIA','ARMENIO\n'),(14,'ABW','ARUBA','NEERLANDES\n'),(15,'AUS','AUSTRALIA','AUSTRALIANO\n'),(16,'AUT','AUSTRIA','AUSTRIACO\n'),(17,'AZE','AZERBAIYAN','AZERBAIYANO\n'),(18,'BHS','BAHAMAS','BAHAMES\n'),(19,'BHR','BAHREIN','DE BAHREIN\n'),(20,'BGD','BANGLADESH','DE BANGLADESH\n'),(21,'BRB','BARBADOS','BARBADENSE\n'),(22,'BLR','BELARUS','BELARUSO\n'),(23,'BEL','BELGICA','BELGA\n'),(24,'BLZ','BELICE','BELICEÃ‘O\n'),(25,'BEN','BENIN','BENINES\n'),(26,'BMU','BERMUDA','BRITANICO\n'),(27,'BTN','BHUTAN','BHUTANES\n'),(28,'BOL','BOLIVIA','BOLIVIANO\n'),(29,'BIH','BOSNIA Y HERZEGOVINA','DE BOSNIA Y HERZEGOVINA\n'),(30,'BWA','BOTSWANA','BOTSWANES\n'),(31,'BRA','BRASIL','BRASILEÃ‘O\n'),(32,'BRN','BRUNEI DARUSSALAM','DE BRUNEI DARUSSALAM\n'),(33,'BGR','BULGARIA','BULGARO\n'),(34,'BFA','BURKINA FASO','BURKINABE\n'),(35,'BDI','BURUNDI','BURUNDIANO\n'),(36,'CPV','CABO VERDE','CABOVERDIANO\n'),(37,'KHM','CAMBOYA','CAMBOYANO\n'),(38,'CMR','CAMERUN','CAMERUNES\n'),(39,'CAN','CANADA','CANADIENSE\n'),(40,'TCD','CHAD','CHADIANO\n'),(41,'CHL','CHILE','CHILENO\n'),(42,'CHN','CHINA','CHINO\n'),(43,'CYP','CHIPRE','CHIPRIOTA\n'),(44,'COL','COLOMBIA','COLOMBIANO\n'),(45,'COM','COMORAS','COMORANO\n'),(46,'COG','CONGO','CONGOLEÃ‘O\n'),(47,'CIV','COSTA DE MARFIL','DE COSTA DE MARFIL\n'),(48,'CRI','COSTA RICA','COSTARRICENSE\n'),(49,'HRV','CROACIA','CROATA\n'),(50,'CUB','CUBA','CUBANO\n'),(51,'DNK','DINAMARCA','DANES/DINAMARQUES\n'),(52,'DJI','DJIBOUTI','DE DJIBOUTI\n'),(53,'DMA','DOMINICA','DE DOMINICA\n'),(54,'ECU','ECUADOR','ECUATORIANO\n'),(55,'EGY','EGIPTO','EGIPCIO\n'),(56,'SLV','EL SALVADOR','SALVADOREÃ‘O\n'),(57,'ARE','EMIRATOS ARABES UNIDOS','DE LOS EMIRATOS ARABES UNIDOS\n'),(58,'ERI','ERITREA','ERITREO\n'),(59,'SVK','ESLOVAQUIA','ESLOVACO\n'),(60,'SVN','ESLOVENIA','ESLOVENO\n'),(61,'ESP','ESPAÃ‘A','ESPAÃ‘OL\n'),(62,'USA','ESTADOS UNIDOS DE AMERICA','ESTADOUNIDENSE\n'),(63,'EST','ESTONIA','ESTONIO\n'),(64,'ETH','ETIOPIA','ETIOPE\n'),(65,'RUS','FEDERACION DE RUSIA','DE LA FEDERACION DE RUSIA\n'),(66,'FJI','FIJI','DE FIJI\n'),(67,'PHL','FILIPINAS','FILIPINO\n'),(68,'FIN','FINLANDIA','FINLANDES\n'),(69,'FRA','FRANCIA','FRANCES\n'),(70,'GAB','GABON','GABONES\n'),(71,'GMB','GAMBIA','GAMBIANO\n'),(72,'GEO','GEORGIA','GEORGIANO\n'),(73,'GHA','GHANA','GHANES\n'),(74,'GIB','GIBRALTAR','BRITANICO\n'),(75,'GRD','GRANADA','GRANADINO\n'),(76,'GRC','GRECIA','GRIEGO\n'),(77,'GRL','GROENLANDIA','DANES\n'),(78,'GLP','GUADALUPE','GUADALUPANO\n'),(79,'GUM','GUAM','ESTADOUNIDENSE\n'),(80,'GTM','GUATEMALA','GUATEMALTECO\n'),(81,'GUF','GUAYANA FRANCESA','FRANCES GUYANES\n'),(82,'GIN','GUINEA','GUINEO\n'),(83,'GNB','GUINEA BISSAU','DE GUINEA BISSAU\n'),(84,'GNQ','GUINEA ECUATORIAL','GUINEANO\n'),(85,'GUY','GUYANA','GUYANES\n'),(86,'HTI','HAITI','HAITIANO\n'),(87,'HND','HONDURAS','HONDUREÃ‘O\n'),(88,'HKG','HONG KONG','CHINO\n'),(89,'HUN','HUNGRIA','HUNGARO\n'),(90,'IND','INDIA','INDU/INDIO\n'),(91,'IDN','INDONESIA','INDONESIO\n'),(92,'IRN','IRAN','IRANI\n'),(93,'IRQ','IRAQ','IRAQUI\n'),(94,'IRL','IRLANDA','IRLANDES\n'),(95,'BVT','ISLA BOUVET','NORUEGO\n'),(96,'CXR','ISLA DE CHRISTMAS','AUSTRALIANO\n'),(97,'NFK','ISLA NORFOLK','AUSTRALIANO\n'),(98,'ISL','ISLANDIA','ISLANDES\n'),(99,'CYM','ISLAS CAIMAN','BRITANICO\n'),(100,'COK','ISLAS COOK','DE LAS ISLAS COOK\n'),(101,'CCK','ISLAS DE COCOS (KEELING)','DE AUSTRALIA\n'),(102,'FLK','ISLAS FALKLAND (MALVINAS)','BRITANICO\n'),(103,'FRO','ISLAS FAROE','DANES\n'),(104,'SGS','ISLAS GEORGIA DEL SUR Y SANDWICH DEL SUR','BRITANICO\n'),(105,'HMD','ISLAS HEARD Y MCDONALD','AUSTRALIANO\n'),(106,'MNP','ISLAS MARIANAS DEL NORTE','ESTADOUNIDENSE\n'),(107,'MHL','ISLAS MARSHALL','DE LAS ISLAS MARSHALL\n'),(108,'UMI','ISLAS MENORES PERIFERICAS DE ESTADOS UNIDOS DE AME','ESTADOUNIDENSE\n'),(109,'SLB','ISLAS SALOMON','DE LAS ISLAS SALOMON\n'),(110,'TCA','ISLAS TURCAS Y CAICOS','BRITANICO\n'),(111,'VGB','ISLAS VIRGENES BRITANICAS','BRITANICO\n'),(112,'VIR','ISLAS VIRGENES DE ESTADOS UNIDOS DE AMERICA','ESTADOUNIDENSE\n'),(113,'ISR','ISRAEL','ISRAELI\n'),(114,'ITA','ITALIA','ITALIANO\n'),(115,'JAM','JAMAICA','JAMAIQUINO\n'),(116,'JPN','JAPON','JAPONES\n'),(117,'JOR','JORDANIA','JORDANO\n'),(118,'KAZ','KAZAJSTAN','KAZAKO\n'),(119,'KEN','KENIA','KENIANO\n'),(120,'KGZ','KIRGUISTAN','KIRGUIS\n'),(121,'KIR','KIRIBATI','KIRIBATIANO\n'),(122,'KWT','KUWAIT','KUWAITI\n'),(123,'LSO','LESOTHO','LESOTHO\n'),(124,'LVA','LETONIA','LETON\n'),(125,'LBN','LIBANO','LIBANES\n'),(126,'LBR','LIBERIA','LIBERIANO\n'),(127,'LBY','LIBIA','LIBIO\n'),(128,'LIE','LIECHTENSTEIN','DE LIECHTENSTEIN\n'),(129,'LTU','LITUANIA','LITUANO\n'),(130,'LUX','LUXEMBURGO','LUXEMBURGUES\n'),(131,'MAC','MACAU','CHINO\n'),(132,'MKD','MACEDONIA','MACEDONIO\n'),(133,'MDG','MADAGASCAR','MALGACHE\n'),(134,'MYS','MALASIA','MALASIO\n'),(135,'MWI','MALAWI','MALAWIANO\n'),(136,'MDV','MALDIVAS','MALDIVO\n'),(137,'MLI','MALI','MALIENSE\n'),(138,'MLT','MALTA','MALTES\n'),(139,'MAR','MARRUECOS','MARROQUI\n'),(140,'MTQ','MARTINICA','FRANCES\n'),(141,'MUS','MAURICIO','MAURICIANO\n'),(142,'MRT','MAURITANIA','MAURITANO\n'),(143,'MYT','MAYOTTE','FRANCES\n'),(144,'MEX','MEXICO','MEXICANO\n'),(145,'FSM','MICRONESIA','DE LOS ESTADOS FEDERADOS DE MICRONESIA\n'),(146,'MCO','MONACO','MONEGASCO\n'),(147,'MNG','MONGOLIA','MONGOL\n'),(148,'MSR','MONTSERRAT','BRITANICO\n'),(149,'MOZ','MOZAMBIQUE','MOZAMBIQUEÃ‘O\n'),(150,'MMR','MYANMAR','DE MYANMAR\n'),(151,'NAM','NAMIBIA','NAMIBIANO\n'),(152,'NRU','NAURU','NAURUANO\n'),(153,'NPL','NEPAL','NEPALES\n'),(154,'NIC','NICARAGUA','NICARAGÃœENSE\n'),(155,'NER','NIGER','NIGERINO\n'),(156,'NGA','NIGERIA','NIGERIANO\n'),(157,'NIU','NIUE','DE NIUE\n'),(158,'NOR','NORUEGA','NORUEGO\n'),(159,'NCL','NUEVA CALEDONIA','FRANCES\n'),(160,'NZL','NUEVA ZELANDIA','NEOZELANDES\n'),(161,'OMN','OMAN','OMANI\n'),(162,'NLD','PAISES BAJOS','HOLANDES\n'),(163,'PAK','PAKISTAN','PAKISTANI\n'),(164,'PLW','PALAU','DE PALAU\n'),(165,'PAN','PANAMA','PANAMEÃ‘O\n'),(166,'PNG','PAPUA NUEVA GUINEA','DE PAPUA NUEVA GUINEA\n'),(167,'PRY','PARAGUAY','PARAGUAYO\n'),(168,'PER','PERU','PERUANO\n'),(169,'PCN','PITCAIRN','BRITANICO\n'),(170,'PYF','POLINESIA FRANCESA','FRANCES\n'),(171,'POL','POLONIA','POLACO\n'),(172,'PRT','PORTUGAL','PORTUGUES\n'),(173,'PRI','PUERTO RICO','ESTADOUNIDENSE\n'),(174,'QAT','QATAR','DE QATAR\n'),(175,'GRB','REINO UNIDO DE GRAN BRETAÃ‘A E IRLANDA DEL NORTE','BRITANICO\n'),(176,'SYR','REPUBLICA ARABE SIRIA','SIRIO\n'),(177,'CAF','REPUBLICA CENTROAFRICANA','CENTROAFRICANO\n'),(178,'CZE','REPUBLICA CHECA','CHECO\n'),(179,'KOR','REPUBLICA DE COREA','DE LA REPUBLICA DE COREA\n'),(180,'MDA','REPUBLICA DE MOLDOVA','MOLDOVO\n'),(181,'COD','REPUBLICA DEMOCRATICA DEL CONGO','DE REPUBLICA DEMOCRATICA DEL CONGO\n'),(182,'LAO','REPUBLICA DEMOCRATICA POPULAR DE LAO','LAOSIANO\n'),(183,'DMO','REPUBLICA DOMINICANA','DOMINICANO\n'),(184,'PRK','REPUBLICA POPULAR DEMOCRATICA DE COREA','DE LA REPUBLICA POPULAR DEMOCRATICA DE COREA\n'),(185,'TZA','REPUBLICA UNIDA DE TANZANIA','TANZANIANO\n'),(186,'REU','REUNION','FRANCES\n'),(187,'ROM','RUMANIA','RUMANO\n'),(188,'RWA','RWANDA','RWANDES\n'),(189,'ESH','SAHARA OCCIDENTAL','MARROQUI\n'),(190,'WSM','SAMOA','SAMOANO\n'),(191,'ASM','SAMOA AMERICANA','ESTADOUNIDENSE\n'),(192,'KNA','SAN CRISTOBAL Y NEVIS','DE SAN CRISTOBAL Y NEVIS\n'),(193,'SMR','SAN MARINO','SANMARINENSE\n'),(194,'SPM','SAN PIERRE Y MIQUELON','FRANCES\n'),(195,'VCT','SAN VICENTE Y LAS GRANADINAS','DE SAN VICENTE Y LAS GRANADINAS\n'),(196,'SHN','SANTA HELENA','BRITANICO\n'),(197,'LCA','SANTA LUCIA','SANTALUCENSE\n'),(198,'VAT','SANTA SEDE (ESTADO CIUDAD DEL VATICANO)','DE LA SANTA SEDE\n'),(199,'STP','SANTO TOME Y PRINCIPE','DE SANTO TOME Y PRINCIPE\n'),(200,'SEN','SENEGAL','SENEGALES\n'),(201,'SYC','SEYCHELLES','DE SEYCHELLES\n'),(202,'SLE','SIERRA LEONA','SIERRALEONES\n'),(203,'SGP','SINGAPUR','SINGAPURENSE\n'),(204,'SOM','SOMALIA','SOMALI\n'),(205,'LKA','SRI LANKA','DE SRI LANKA\n'),(206,'ZAF','SUDAFRICA','SUDAFRICANO\n'),(207,'SDN','SUDAN','SUDANES\n'),(208,'SWE','SUECIA','SUECO\n'),(209,'CHE','SUIZA','SUIZO\n'),(210,'SUR','SURINAME','SURINAMES\n'),(211,'SJM','SVALBARD Y JAN MAYEN','NORUEGO\n'),(212,'SWZ','SWAZILANDIA','SWAZI\n'),(213,'THA','TAILANDIA','TAILANDES\n'),(214,'TWN','TAIWAN','CHINO\n'),(215,'TJK','TAYIKISTAN','TAYIK\n'),(216,'IOT','TERRITORIO BRITANICO DEL OCEANO INDICO','BRITANICO\n'),(217,'ATF','TERRITORIOS FRANCESES DEL SUR','FRANCES\n'),(218,'TMP','TIMOR DEL ESTE','AUSTRALIANO\n'),(219,'TGO','TOGO','TOGOLES\n'),(220,'TKL','TOKELAU','NEOZELANDES\n'),(221,'TON','TONGA','TONGANO\n'),(222,'TTO','TRINIDAD Y TOBAGO','DE TRINIDAD Y TOBAGO\n'),(223,'TUN','TUNEZ','TUNECINO\n'),(224,'TKM','TURKMENISTAN','TURCOMANO\n'),(225,'TUR','TURQUIA','TURCO\n'),(226,'TUV','TUVALU','DE TUVALU\n'),(227,'UKR','UCRANIA','UCRANIO\n'),(228,'UGA','UGANDA','UGANDES\n'),(229,'URY','URUGUAY','URUGUAYO\n'),(230,'UZB','UZBEKISTAN','UZBEKO\n'),(231,'VUT','VANUATU','DE VANUATU\n'),(232,'VEN','VENEZUELA','VENEZOLANO\n'),(233,'VNM','VIETNAM','VIETNAMITA\n'),(234,'WLF','WALLIS Y FUTUNA','FRANCES\n'),(235,'YEM','YEMEN','YEMENITA\n'),(236,'YUG','YUGOSLAVIA','YUGOSLAVO\n'),(237,'ZMB','ZAMBIA','ZAMBIANO\n'),(238,'ZWE','ZIMBABWE','ZIMBABWENSE\n');
/*!40000 ALTER TABLE `nacionalidads` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `negocios`
--

LOCK TABLES `negocios` WRITE;
/*!40000 ALTER TABLE `negocios` DISABLE KEYS */;
INSERT INTO `negocios` VALUES (2,'OO','O','O','99',999,6,1),(5,'oo','o','o','0',9,7,1),(6,'OOO','OO','OO','999',999,8,1);
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
  `cliente_id` int(11) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
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
  `st` int(11) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periodos`
--

LOCK TABLES `periodos` WRITE;
/*!40000 ALTER TABLE `periodos` DISABLE KEYS */;
INSERT INTO `periodos` VALUES (1,'Diarios',1),(2,'Semanales',7),(3,'Quincenales',15),(4,'Mensuales',30),(5,'Bimestrales',60),(6,'Semestrales',180),(7,'Anuales',365),(8,NULL,NULL),(9,NULL,NULL);
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
  `intereses` float DEFAULT NULL,
  `moratorio` float DEFAULT NULL,
  `ahorro` float DEFAULT NULL,
  `periodo_id` int(11) DEFAULT NULL,
  `st` int(11) DEFAULT NULL,
  `num_pagos` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'FOMMUR PRIMER CICLO',2.5,2.5,100,2,1,16);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotors`
--

LOCK TABLES `promotors` WRITE;
/*!40000 ALTER TABLE `promotors` DISABLE KEYS */;
INSERT INTO `promotors` VALUES (1,'HERNANDEZ','JIMENEZ','MARIA DOLORES','ooooo','9999','999','999999','jjdjdjdjd',NULL);
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
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'fondeos'),(2,'capturistas'),(3,'promotores'),(4,'gerentes'),(5,'administradores');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  KEY `index_roles_users_on_role_id` (`role_id`),
  KEY `index_roles_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (1,5);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rols`
--

LOCK TABLES `rols` WRITE;
/*!40000 ALTER TABLE `rols` DISABLE KEYS */;
INSERT INTO `rols` VALUES (1,'clientes',NULL),(2,'capturistas',NULL),(3,'promotores',NULL),(4,'gerentes',NULL),(5,'administradores',NULL);
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
INSERT INTO `schema_info` VALUES (41);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sectors`
--

LOCK TABLES `sectors` WRITE;
/*!40000 ALTER TABLE `sectors` DISABLE KEYS */;
INSERT INTO `sectors` VALUES (1,'AGRICULTURA',NULL),(3,'VACUNO',NULL);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subsectors`
--

LOCK TABLES `subsectors` WRITE;
/*!40000 ALTER TABLE `subsectors` DISABLE KEYS */;
INSERT INTO `subsectors` VALUES (1,'RECOLECCION',1,NULL);
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
  `st` int(11) DEFAULT NULL,
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
  `controller_id` int(11) DEFAULT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `consultar` int(11) DEFAULT '1',
  `actualizar` int(11) DEFAULT '0',
  `insertar` int(11) DEFAULT '1',
  `eliminar` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `systables`
--

LOCK TABLES `systables` WRITE;
/*!40000 ALTER TABLE `systables` DISABLE KEYS */;
INSERT INTO `systables` VALUES (1,1,1,1,0,1,1),(2,1,2,1,0,1,1),(3,1,3,1,0,1,1),(4,1,4,1,0,1,1),(5,1,5,1,0,1,1);
/*!40000 ALTER TABLE `systables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transferencias`
--

DROP TABLE IF EXISTS `transferencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transferencias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `origen_id` int(11) DEFAULT NULL,
  `destino_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `monto` varchar(255) DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transferencias`
--

LOCK TABLES `transferencias` WRITE;
/*!40000 ALTER TABLE `transferencias` DISABLE KEYS */;
INSERT INTO `transferencias` VALUES (1,1,2,1,'2010-08-02','35000',NULL,NULL),(2,2,1,1,'2010-08-02','10000',NULL,NULL);
/*!40000 ALTER TABLE `transferencias` ENABLE KEYS */;
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'administrador','db9c93f05d2e41dc2256c3890d5d78ca6e48d418','administrador del sistema',5,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viviendas`
--

LOCK TABLES `viviendas` WRITE;
/*!40000 ALTER TABLE `viviendas` DISABLE KEYS */;
INSERT INTO `viviendas` VALUES (1,'BIOCASA O CASA'),(2,'DE ADOBE'),(3,'DE LADRILLO'),(4,'DE MADERA'),(5,'DE MATERIAL MIXTO'),(6,'DE PAJAS, RAMAS O CAÃ‘AS'),(7,'DE PIEDRA'),(8,'APARTAMENTO'),(9,'DEPARTAMENTO');
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

-- Dump completed on 2010-08-12 14:08:46
