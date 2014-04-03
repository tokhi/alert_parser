# myapp.rb
require 'sinatra'
#require 'sinatra/cross_origin'
require 'open-uri'
#require 'gon-sinatra'
require 'nokogiri'
#require 'pp'
require 'digest/sha1'
require 'koala'
require './url_encode_decode'
include EncodeDecode

$remote_url = nil
$alert_hashes = "public/xml/hash.log"

get '/index' do
  @url = "http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525"
  @doc = Nokogiri::XML(open(@url))


  erb :index
end

def parse_alert(url)
  # puts "-->URL:  #{url}"
  @doc = nil
  begin
    @doc = Nokogiri::XML(open(url))
  rescue
    puts "exctpion: "
  end
  # # --> BEGIN PARSING
  # doc.search("entry").each do |node|
  #   title = node.search("title")
  #   link = node.search("link")
  #   content = node.search("content")

  #   puts "title: #{title.text}"
  # end # ~> END xpath
end


get '/' do
  $remote_url = nil
  redirect '/index'
end
# create a fake url to render user to the article page.
get '/render' do
  puts "path triggered"
  puts "params: #{params["link"]}"
  $remote_url = url_decode(params["link"])
  redirect '/index'
end

def check_hash(title,link)


  begin
    hashes_array = File.open($alert_hashes, "r").read().split("\n")
  rescue
    hashes_array = []
  end

  hash_data = Digest::SHA1.hexdigest(title)

  if hashes_array.include? hash_data
    return nil
  else
    post_to_page(title, link)
    File.open($alert_hashes, "a") { |io|  io.write(hash_data+"\n")}
    hashes_array.push(hash_data)

    file_size = '%.2f' % (File.size($alert_hashes).to_f / 1024)
    if file_size.to_f >= 6.00
      FileUtils.rm($alert_hashes)
      hashes_array = []
    end
  end

end

def post_to_page(title, link)
  link = "http://rtnews.herokuapp.com/render?link="+link
  #puts "the link: #{link}"
  # oauth_access_token = "CAAGNaXtMjiUBAFuWwhIAZABMEQFeuZAhDCGZAjXio5Q52ZCyCFFdoIFjlRS6oPMCc6ZA7hlZB09LZBJQblZBo2xtrHXSiThOBRZBJxNowFaXCr4z7q72BINW817w6Y518gFDZBXLbvXkTSZAJWXXpfMNw0spd7Q1GMI474kF3yyTefZArRJ63FHP9446tJ7JOGAAhW4ZD"
  # @graph = Koala::Facebook::API.new(oauth_access_token)
  # strip html tags
  title = title.gsub(/<\/?[^>]*>/, "")
  title = title.gsub("<b>", "")
  title = title.gsub("</b>", "")
  #@graph.put_object(1477394625806542, "feed", :message => title,:link=>link)

end

def validate_google_redirect_url(link)
  link = link.gsub("https://www.google.com/url?q=","")
  link = link.split("&ct=ga&cd=")[0]
  link
end

def url_encode(url)
   link = EncodeDecode.encode(url)
  puts "e ~> #{link}"
  link
end

def url_decode(url)
  link = EncodeDecode.decode(url)
  puts "d~> #{link}"
  link
  end
