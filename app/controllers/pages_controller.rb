require 'uri'
require 'net/http'


class PagesController < ApplicationController
  def home
    @title="Home"
  end

  def contact
    @title ="contact"
  end

  def help
    @title ="help"
  end

  def match
    @title="match"
    url = "http://www.mobiofy.com/tools/wishserver/pcs.php?format=json"
    @uri = Net::HTTP.get_response(URI.parse(url))
    @uri = @uri.body
    @uri_json =  JSON.parse(@uri)

  end

  def search


  end
  def signin
    @user =User.new

  end
  def sign_out

  end

end
