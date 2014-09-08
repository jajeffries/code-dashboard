require 'net/http'
require 'openssl'

class AppStore
  def initialize(app_store_home)
    @app_store_home = app_store_home
  end

  def get_response_for_app(app_page_url)   
    http = Net::HTTP.new(@app_store_home, Net::HTTP.https_default_port())
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
    response = http.request( Net::HTTP::Get.new(app_page_url) )
    throw "Cannot connect to app store #{@app_store_home}" if response.code != "200"
    return response
  end
end 