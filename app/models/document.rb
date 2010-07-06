class Document
  include Config
  def self.generate_report_xml(ds_data, report_design, output_type, select_criteria, report_params)
    #--- Aqui vamos a checar de que tipo es el datasource
       report_design << '.jasper' if !report_design.match(/\.jasper$/)
       interface_classpath=Dir.getwd+"/app/jasper/bin"
       case CONFIG['host']
        when /mswin32/
          mode = "w+b" #windows requires binary mode
          Dir.foreach(Dir.getwd+"/app/jasper/lib") do |file|
          interface_classpath << ";#{Dir.getwd}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
        end
        else
         mode = "w+"
          Dir.foreach(Dir.getwd+"/app/jasper/lib") do |file|
          interface_classpath << ":#{Dir.getwd}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
          end
        end
        result=nil
		    IO.popen "java -Djava.awt.headless=true -cp \"#{interface_classpath}\" XmlJasperInterface -o#{output_type} -f#{Dir.getwd}/app/reports/#{report_design} #{report_params} -x#{select_criteria}", mode do |pipe|
			  pipe.write ds_data
			  pipe.close_write
			  result = pipe.read
			  pipe.close
        end

     return result
end

  def self.generate_report_jdbc(report_design, output_type, report_params)
       report_design << '.jasper' if !report_design.match(/\.jasper$/)
       interface_classpath=Dir.getwd+"/app/jasper/bin"
       case CONFIG['host']
        when /mswin32/
          mode = "w+b" #windows requires binary mode
          Dir.foreach(Dir.getwd+"/app/jasper/lib") do |file|
          interface_classpath << ";#{Dir.getwd}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
        end
        else
         mode = "w+"
          Dir.foreach(Dir.getwd+"/app/jasper/lib") do |file|
          interface_classpath << ":#{Dir.getwd}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
          end
        end

        results=nil
        config = YAML.load_file(File.join(RAILS_ROOT, 'config', 'database.yml'))[RAILS_ENV]
        host, database, username, password, port = config['host'], config['database'], config['username'], config['password'], config['port']
        case config['adapter']
        when "mysql"
          jdbc_driver = "com.mysql.jdbc.Driver"
        when "postgresql"
          jdbc_driver = "org.postgresql.Driver"
        end

        jdbc_url= "jdbc:#{config['adapter']}://#{host}:#{port}/#{database}"
        exec = "java -Djava.awt.headless=true -cp \"#{interface_classpath}\" XmlJasperInterface -Duser.language=es -Duser.region=MX -o#{output_type} -f#{Dir.getwd}/app/reports/#{report_design} #{report_params} -d\"#{jdbc_driver}\" -u\"#{jdbc_url}\" -n\"#{username}\" -p\"#{password}\""
	      IO.popen(exec, "r") do |pipe|
	        results = pipe.read
	        pipe.close
	      end
   return results
 end







end


