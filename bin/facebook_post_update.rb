require 'nokogiri'
require 'open-uri'
require 'digest/sha1'
require 'koala'
require 'daemons'
require './url_encode_decode'
include EncodeDecode
require "base64"

def check_hash(title,link)

  $alert_hashes = "hash.log"
  begin
    hashes_array = File.open($alert_hashes, "r").read().split("\n")
  rescue
    hashes_array = []
  end
  # puts "hash_array: #{hashes_array.inspect}"
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
  link = validate_google_redirect_url(link)
  puts "original: #{link}"
  rlink = Base64.encode64(link)
  puts "encoded: #{rlink}"
  link = "http://rtnews.herokuapp.com/render?link="+rlink
  rlink = nil
  #puts "the link: #{link}"
  oauth_access_token = "CAAGNaXtMjiUBAFuWwhIAZABMEQFeuZAhDCGZAjXio5Q52ZCyCFFdoIFjlRS6oPMCc6ZA7hlZB09LZBJQblZBo2xtrHXSiThOBRZBJxNowFaXCr4z7q72BINW817w6Y518gFDZBXLbvXkTSZAJWXXpfMNw0spd7Q1GMI474kF3yyTefZArRJ63FHP9446tJ7JOGAAhW4ZD"
  @graph = Koala::Facebook::API.new(oauth_access_token)
  # strip html tags
  title = title.gsub(/<\/?[^>]*>/, "")
  title = title.gsub("<b>", "")
  title = title.gsub("</b>", "")
  puts "try to post ..."
  #@graph.put_object(1477394625806542, "feed", :message => title,:link=>link)

end

def validate_google_redirect_url(link)
  link = link.gsub("https://www.google.com/url?q=","")
  link = link.split("&ct=ga&cd=")[0]
end

def parse_alert(url)
  @doc = nil
  begin
    @doc = Nokogiri::XML(open(url))
  rescue  Exception => e
    puts "nokogiri: exctpion while parsing the url : #{e.message}"
  end


  # --> BEGIN PARSING
  @doc.search("entry").each do |node|
    # puts "\n"+@doc
    title = node.search("title").text
    link = node.css('link').map { |link| link['href'] }[0]
    check_hash(title, link)
  end # ~> END xpath
end

# seconds = 3600 # seconds
# options = {
#   :multiple   => false,
#   :ontop      => false,
#   :backtrace  => true,
#   :log_output => true,
#   :monitor    => false
# }

# Daemons.run_proc('fb_update', {:ontop => true}) do
@url = "http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525"
parse_alert(@url)
#     sleep(seconds)
# end
