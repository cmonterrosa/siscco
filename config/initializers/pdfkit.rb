# config/initializers/pdfkit.rb
PDFKit.configure do |config|
#  config.wkhtmltopdf = '/usr/bin/wkhtmltopdf'
  config.default_options = {
    :page_size => 'letter',
    :margin_top => '0.5in',
    :margin_right => '0.45in',
    :margin_bottom => '0.5in',
    :margin_left => '0.45in',
    :encoding => 'utf-8',
    :header_right => "Hora: [time]",
    :footer_right => "Pagina [page] de [toPage]"
  }
end
