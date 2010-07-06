# app/helpers/send_doc_helper.rb
module SendDocHelper

  protected
  def cache_hack
    p request.env['HTTP_USER_AGENT']
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = ''
      headers['Cache-Control'] = ''
    else
      headers['Pragma'] = 'no-cache'
      headers['Cache-Control'] = 'no-cache, must-revalidate'
    end
    p headers
  end

  def send_doc(xml, xml_start_path, report, filename, output_type = 'pdf')
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
    send_data Document.generate_report(xml, report, jasper_type, xml_start_path),
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
    send_data Document.generate_report_xml(ds_data, report, jasper_type, xml_start_path, report_params),
              :filename => "#{filename}.#{extension}", :type => mime_type, :disposition => 'inline'
   end


end
