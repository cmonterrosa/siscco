# app/helpers/send_doc_helper.rb
module SendDocHelper
  protected
  def cache_hack
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = ''
      headers['Cache-Control'] = ''
    else
      headers['Pragma'] = 'no-cache'
      headers['Cache-Control'] = 'no-cache, must-revalidate'
    end
  end


  def send_doc_jdbc(report, filename,  report_params, output_type = 'pdf')
     case output_type
    when 'rtf'
      extension = 'rtf'
      mime_type = 'application/rtf'
      jasper_type = 'rtf'
    else # pdf
      extension = 'pdf'
      mime_type = 'application/pdf'
      jasper_type = 'pdf'
    end
    cache_hack
     send_data Document.generate_report_jdbc(report, jasper_type, format_params(report_params)),
        :filename => "#{filename}.#{extension}", :type => mime_type, :disposition => 'inline'
  end


   def send_doc_xml(ds_data, xml_start_path, report, filename, report_params, output_type = 'pdf')
    case output_type
    when 'rtf'
      extension = 'rtf'
      mime_type = 'application/rtf'
      jasper_type = 'rtf'
    else # pdf
      extension = 'pdf'
      mime_type = 'application/pdf'
      jasper_type = 'pdf'
    end
    cache_hack
    send_data Document.generate_report_xml(ds_data, report, jasper_type, xml_start_path, format_params(report_params)),
              :filename => "#{filename}.#{extension}", :type => mime_type, :disposition => 'inline'
   end

   def format_params(parameters)
     @params_string =  ""
     parameters.each_key do |k|
         if parameters[k][:tipo] == "String"
            @params_string << "-r#{k}@@#{parameters[k][:tipo]}@@\"#{parameters[k][:valor]}\" "
         else
           @params_string << "-r#{k}@@#{parameters[k][:tipo]}@@#{parameters[k][:valor]} "
         end
     end
    @params_string
   end


end
