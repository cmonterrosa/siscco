-- MySQL dump 10.13  Distrib 5.1.35, for apple-darwin9.5.0 (i386)
--
-- Host: localhost    Database: ultima
-- ------------------------------------------------------
-- Server version	5.1.35

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
  `colonia_id` int(11) DEFAULT NULL,
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bancos`
--

LOCK TABLES `bancos` WRITE;
/*!40000 ALTER TABLE `bancos` DISABLE KEYS */;
INSERT INTO `bancos` VALUES (4,'BANORTE','9999','LIC. MENDEZ','9999999','999999',10,1);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (5,'MONTERROSA','LOPEZ','CARLOS','2010-07-26','MOLC8509121S0','MOLC850912HCSNPR02','XX','M','MEXICANA','PRIVADA','FISICA','X','9','9','9',1,1,1,10,1),(6,'HERNANDEZ','ESCOBAR','RAFAEL','2010-07-26','XXXXXXXXXX','XXXXXXXXXXXXXXXXXX','CCCCC','M','MEXICANA','PRIVADA','FISICA','xxxxxXX','9','0','0',1,3,1,10,0),(7,'DEL CARPIO','MENDEZ','o','2010-07-26','cccccccccccc9','cccccccccccccccccc','iiiiii','M','MEXICANA','PRIVADA','FISICA','iiii','0999','9','9',1,1,1,10,1),(8,'PEREZ','FUENTES','ITZEL','2010-07-26','PPPPPPPPPPPP','PPPPPPPPPPPPPPPPP5','OPOPOPOP','M','MEXICANA','PRIVADA','FISICA CON ACTIVIDAD EMPRESARIAL','OOOO','9999','4555','XXXXXX',1,6,1,10,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes_grupos`
--

LOCK TABLES `clientes_grupos` WRITE;
/*!40000 ALTER TABLE `clientes_grupos` DISABLE KEYS */;
INSERT INTO `clientes_grupos` VALUES (5,2,NULL,NULL,NULL,1),(5,1,1,NULL,NULL,2),(NULL,2,1,'2010-07-26 21:25:57',NULL,4),(NULL,2,1,'2010-07-26 21:27:04',NULL,5),(NULL,2,1,'2010-07-26 21:35:02',NULL,6),(NULL,2,1,'2010-07-26 21:38:48',NULL,7),(NULL,2,1,'2010-07-26 21:40:31',NULL,8),(7,2,1,'2010-07-26 21:43:17',NULL,9),(8,3,1,'2010-07-26 21:56:11',NULL,10);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colonias`
--

LOCK TABLES `colonias` WRITE;
/*!40000 ALTER TABLE `colonias` DISABLE KEYS */;
INSERT INTO `colonias` VALUES (1,'CENTRO',NULL,1,NULL),(2,'LA LOMITA',NULL,1,NULL),(3,'24 DE JUNIO',NULL,1,NULL),(4,'POTINASPAK',NULL,1,NULL),(5,'POMAROSA',NULL,1,NULL),(6,'COPOYA',NULL,2,NULL),(7,'LAURELES',NULL,3,NULL),(8,'CENTRO',NULL,3,NULL),(9,'VISTAHERMOSA',NULL,3,NULL),(10,'PLAYA LINDA',NULL,4,NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditos`
--

LOCK TABLES `creditos` WRITE;
/*!40000 ALTER TABLE `creditos` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ejidos`
--

LOCK TABLES `ejidos` WRITE;
/*!40000 ALTER TABLE `ejidos` DISABLE KEYS */;
INSERT INTO `ejidos` VALUES (1,'TUXTLA GUTIERREZ',NULL,1,NULL),(2,'EL JOBO',NULL,1,NULL),(3,'LOS NARANJOS',NULL,2,NULL),(4,'LAS FLORES',NULL,2,NULL);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `festivos`
--

LOCK TABLES `festivos` WRITE;
/*!40000 ALTER TABLE `festivos` DISABLE KEYS */;
INSERT INTO `festivos` VALUES (1,'2010-05-01','dia del trabajo',NULL);
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
  `user_id` int(11) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fondeos`
--

LOCK TABLES `fondeos` WRITE;
/*!40000 ALTER TABLE `fondeos` DISABLE KEYS */;
INSERT INTO `fondeos` VALUES (1,'FOMMUR',NULL,NULL);
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
INSERT INTO `grupos` VALUES (1,'Ninguno',NULL),(2,'LOS GIRASOLES',NULL),(3,'LOS PETATES',NULL);
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
  `st` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lineas`
--

LOCK TABLES `lineas` WRITE;
/*!40000 ALTER TABLE `lineas` DISABLE KEYS */;
INSERT INTO `lineas` VALUES (1,'99999999','2010-07-26',300000,'ACTIVA','A',1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,'INSERTAR','2010-07-26 22:15:03','Banco',NULL,1,3),(2,'INSERTAR','2010-07-26 22:16:35','Banco',NULL,1,4);
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `miembros`
--

LOCK TABLES `miembros` WRITE;
/*!40000 ALTER TABLE `miembros` DISABLE KEYS */;
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
  `user_id` int(11) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `municipios`
--

LOCK TABLES `municipios` WRITE;
/*!40000 ALTER TABLE `municipios` DISABLE KEYS */;
INSERT INTO `municipios` VALUES (1,'TUXTLA GUTIERREZ',NULL,1,NULL,NULL),(2,'TAPACHULA',NULL,1,NULL,NULL),(3,'SAN CRISTOBAL DE LAS CASAS',NULL,1,NULL,NULL);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'FOMMUR PRIMER CICLO',2.5,2.5,100,2,1);
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
INSERT INTO `schema_info` VALUES (40);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sectors`
--

LOCK TABLES `sectors` WRITE;
/*!40000 ALTER TABLE `sectors` DISABLE KEYS */;
INSERT INTO `sectors` VALUES (1,'AGRICULTURA',NULL),(2,'AGRICULTURA',NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transferencias`
--

LOCK TABLES `transferencias` WRITE;
/*!40000 ALTER TABLE `transferencias` DISABLE KEYS */;
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

-- Dump completed on 2010-07-27  5:21:41
