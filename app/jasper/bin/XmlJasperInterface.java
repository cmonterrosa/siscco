/*
 * An XML Jasper interface; Takes XML data from the standard input
 * and uses JRXmlDataSource to generate Jasper reports in the
 * specified output format using the specified compiled Jasper design.
 * 
 * Inspired by the xmldatasource sample application provided with
 * jasperreports-1.1.0
 */
import java.sql.Connection; 
import java.sql.DriverManager; 
import java.text.ParseException; 
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.data.JRXmlDataSource;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.JRRtfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRTextExporter;
import net.sf.jasperreports.engine.export.JRHtmlExporter; 
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;
import net.sf.jasperreports.engine.export.JRTextExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import java.util.Map;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap; 

public class XmlJasperInterface {
  private static final String TYPE_PDF = "pdf";
  private static final String TYPE_XML = "xml";
  private static final String TYPE_RTF = "rtf";
  private static final String TYPE_XLS = "xls";
  private static final String TYPE_CSV = "csv";
  private static final String TYPE_TXT = "txt";
  private static final String TYPE_HTML = "html"; 
    
  private String outputType;
  private String compiledDesign;
  private String selectCriteria;
  private String char_width = null;
  private String char_height= null;
  private String jdbcDriver; 
  private String jdbcUrl; 
  private String jdbcUser; 
  private String jdbcPassword; 
  private Map parameters = new HashMap();

public static void main(String[] args) throws Exception{
  String outputType = null;
  String compiledDesign = null;
  String selectCriteria = null;
  String char_width = null;
  String char_height= null;
  String jdbcDriver = null; 
  String jdbcUrl = null;; 
  String jdbcUser = null;; 
  String jdbcPassword = null; 
  Map parameters = new HashMap(); 

  if (args.length < 3) {
    printUsage();
    return;
  }

  for (int k = 0; k < args.length; ++k) {
    if (args[k].startsWith("-o"))
      outputType = args[k].substring(2);
    else if (args[k].startsWith("-f"))
      compiledDesign = args[k].substring(2);
    else if (args[k].startsWith("-x"))
      selectCriteria = args[k].substring(2);
    else if (args[k].startsWith("-w"))
      char_width = args[k].substring(2);
    else if (args[k].startsWith("-h"))
      char_height = args[k].substring(2);
    else if (args[k].startsWith("-d")) 
      jdbcDriver = args[k].substring(2); 
    else if (args[k].startsWith("-u")) 
      jdbcUrl = args[k].substring(2); 
    else if (args[k].startsWith("-n")) 
      jdbcUser = args[k].substring(2); 
    else if (args[k].startsWith("-p")) 
      jdbcPassword = args[k].substring(2);
    else if (args[k].startsWith("-r")) { 
      String[] params = args[k].substring(2).split("@@"); 
      if (params.length == 3) { 
	String paramName = params[0]; 
	String paramType = params[1]; 
	String paramValue = params[2]; 
	if (paramName != null && paramName.trim().length() > 0 && paramType != null && paramType.trim().length() > 0 && 
	    paramValue != null && paramValue.trim().length() > 0) { 
	    if (paramType.equalsIgnoreCase("java.util.Date") || paramType.equalsIgnoreCase("Date")) { 
	      Date paramDate = null; 
	      SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy"); 
	      try { 
		  paramDate = sdf.parse(paramValue); 
		  System.out.println(paramDate);
		  parameters.put(paramName, paramDate); 
	      } catch (ParseException ex) { 
		  ex.printStackTrace(); 
	      } 
	    } 
	    if (paramType.equalsIgnoreCase("java.lang.Boolean")|| paramType.equalsIgnoreCase("Boolean")) { 
	      if (paramValue.equalsIgnoreCase("true") || paramValue.equalsIgnoreCase("1") ) 
		  parameters.put(paramName, new Boolean(Boolean.TRUE)); 
	      else  
		  parameters.put(paramName, new Boolean(Boolean.FALSE)); 
	       
	    } 
	    if (paramType.equalsIgnoreCase("java.lang.String") || paramType.equalsIgnoreCase("String")) { 
	      try { 
		parameters.put(paramName, paramValue); 
	      } catch (NumberFormatException ex) { 
		  ex.printStackTrace(); 
	      }
	    } 
	    if (paramType.equalsIgnoreCase("java.lang.Integer") || paramType.equalsIgnoreCase("Integer")) { 
	      try { 
		  parameters.put(paramName, new Integer(paramValue)); 
	      } catch (NumberFormatException ex) { 
		  ex.printStackTrace(); 
	      } 
	    } 
	    if (paramType.equalsIgnoreCase("java.lang.Double") || paramType.equalsIgnoreCase("Double")) { 
	      try { 
		  parameters.put(paramName, new Double(paramValue).doubleValue()); 
	      } catch (NumberFormatException ex) { 
		  ex.printStackTrace(); 
	      } 
	    } 
	  } 
	} 
     }         
  }
  
  
  
  XmlJasperInterface jasperInterface = new XmlJasperInterface(outputType, compiledDesign, selectCriteria, 
  char_width, char_height, jdbcDriver,jdbcUrl, jdbcUser, jdbcPassword, parameters);
  if (!jasperInterface.report()) {
      System.exit(1);
  }
}

public XmlJasperInterface(String outputType, String compiledDesign, String selectCriteria,
  String char_width, String char_height, String jdbcDriver, String jdbcUrl, String jdbcUser, 
  String jdbcPassword, Map parameters) {
  this.outputType = outputType;
  this.compiledDesign = compiledDesign;
  this.selectCriteria = selectCriteria;
  this.char_width  = char_width;
  this.char_height = char_height;
  this.jdbcDriver = jdbcDriver; 
  this.jdbcUrl = jdbcUrl; 
  this.jdbcUser = jdbcUser; 
  this.jdbcPassword = jdbcPassword; 
  this.parameters = parameters; 
}

public boolean report() {
  JasperPrint jasperPrint = new JasperPrint();
  try {
       if (jdbcDriver != null) {
	  Class.forName(jdbcDriver); 
	  //jdbcPassword = "XXX";
	  Connection cn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);  
	  jasperPrint = JasperFillManager.fillReport(compiledDesign, parameters, cn); 
	}
	else{
	  jasperPrint = JasperFillManager.fillReport(compiledDesign, parameters, new JRXmlDataSource(System.in, selectCriteria));
	}
	if (TYPE_TXT.equals(outputType)) {
	  JRTextExporter exporter = new JRTextExporter();
	  exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	  //exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, "salida.txt");
	  exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
	  exporter.setParameter(JRTextExporterParameter.CHARACTER_WIDTH, Float.valueOf(char_width));
	  exporter.setParameter(JRTextExporterParameter.CHARACTER_HEIGHT, Float.valueOf(char_height)); 
	  exporter.exportReport(); 
	}
	else if (TYPE_PDF.equals(outputType)) {
	  JasperExportManager.exportReportToPdfStream(jasperPrint, System.out);
	}
	else if (TYPE_XML.equals(outputType)) {
	  JasperExportManager.exportReportToXmlStream(jasperPrint, System.out);
	}
	else if (TYPE_RTF.equals(outputType)) {
	  JRRtfExporter rtfExporter = new JRRtfExporter();
	  rtfExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	  rtfExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
	  rtfExporter.exportReport();
	}
	else if (TYPE_XLS.equals(outputType)) {
	  JRXlsExporter xlsExporter = new JRXlsExporter();
	  xlsExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	  xlsExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
	  xlsExporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.TRUE);
	  xlsExporter.exportReport();
	}
	else if (TYPE_CSV.equals(outputType)) {
	  JRCsvExporter csvExporter = new JRCsvExporter();
	  csvExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	  csvExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
	  csvExporter.exportReport();
	}
	else if (TYPE_HTML.equals(outputType)) { 
	  JRHtmlExporter htmlExporter = new JRHtmlExporter(); 
	  htmlExporter.setParameter(JRHtmlExporterParameter.JASPER_PRINT, jasperPrint); 
	  htmlExporter.setParameter(JRHtmlExporterParameter.OUTPUT_STREAM, System.out); 
	  htmlExporter.exportReport();
	}
	else{
	  printUsage();
	}
      } catch (JRException e) {
	e.printStackTrace();
	return false;
      } catch (Exception e) {
	e.printStackTrace();
        return false;
      }
      return true;
    }
  
  private static void printUsage() {
    System.out.println("XmlJasperInterface usage:");
    System.out.println("\t If datosource is a XML file");
    System.out.println("\tjava XmlJasperInterface -oOutputType -fCompiledDesign -xSelectExpression < input.xml > report\n");
    System.out.println("\tOutput types:\t\tpdf | xml | rtf | xls | csv | txt");
    System.out.println("\tCompiled design:\tFilename of the compiled Jasper design");
    System.out.println("\tSelect expression:\tXPath expression that specifies the select criteria");
    System.out.println("\t\t\t\t(See net.sf.jasperreports.engine.data.JRXmlDataSource for further information)");
    System.out.println("\tStandard input:\t\tXML input data");
    System.out.println("\tStandard output:\tReport generated by Jasper");
    System.out.println("XmlJasperInterface usage:"); 
    System.out.println("\t If datosource is a Jdbc connection");
    System.out.println("\tjava XmlJasperInterface -oOutputType -fCompiledDesign -dJdbcDriver -uJdbcUrl -nJdbcUser -pJdbcPassword -rReportParameters\n"); 
    System.out.println("\tOutput types:\t\thtml | pdf | xml | rtf | xls | csv"); 
    System.out.println("\tCompiled design:\tFilename of the compiled Jasper design"); 
    System.out.println("\tJDBC Driver:\tJdbc driver class name (jdbc jar/zip must be in lib folder)"); 
    System.out.println("\tJDBC Url:\tJdbc connection URL"); 
    System.out.println("\tJDBC User Name:\tJdbc connection user name"); 
    System.out.println("\tJDBC Password:\tJdbc connection password"); 
    System.out.println("\tReport parameters:\treport parameters (ex.  -rOrderId@@java.lang.Integer@@10)"); 
    System.out.println("\tReport parameters types allowed:\tjava.lang.String (or String), java.lang.Integer (or int), java.lang.Double (or double), java.lang.Boolean (or boolean), java.util.Date"); 
    System.out.println("\tStandard output:\tReport generated by Jasper"); 
  }
 
}
