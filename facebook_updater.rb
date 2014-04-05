require 'nokogiri'
require 'open-uri'
require 'digest/sha1'
require 'koala'
require 'daemons'
require "base64"

module SocialMedia
  @keywords = {"Kabul"=>"#Kabul", "usa"=>"#USA", "USA"=>"#USA", "USArmy"=> "#USArmy", "U.S"=>"#USA", "BBC"=>"#BBC", "CNN"=>"#CNN"}

  def self.check_hash(title,link)

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

  def self.post_to_page(title, link)
    link = validate_google_redirect_url(link)
    #puts "original: #{link}"
    rlink = Base64.encode64(link)
    #puts "encoded: #{rlink}"
    link = "http://rtnews.herokuapp.com/render?link="+rlink
    rlink = nil
    #puts "the link: #{link}"
    oauth_access_token = "CAAGNaXtMjiUBAFuWwhIAZABMEQFeuZAhDCGZAjXio5Q52ZCyCFFdoIFjlRS6oPMCc6ZA7hlZB09LZBJQblZBo2xtrHXSiThOBRZBJxNowFaXCr4z7q72BINW817w6Y518gFDZBXLbvXkTSZAJWXXpfMNw0spd7Q1GMI474kF3yyTefZArRJ63FHP9446tJ7JOGAAhW4ZD"
    @graph = Koala::Facebook::API.new(oauth_access_token)
    # strip html tags
    title = title.gsub(/<\/?[^>]*>/, "")
    title = title.gsub("<b>", "")
    title = title.gsub("</b>", "")
    title = title.gsub("&#39", "")

    @keywords.each do |k,v|
      if title.include?(k)
        title = title.gsub(k,v)
      end
    end   

    if title.include?("Afghanistan") && title.include?("Elections")
      title = title.gsub("Elections","#AfghanElections")
      title << "- #AFG"
    elsif title.include?("Afghanistan") || title.include?("Elections")
      title = title.gsub("elections","#AfghanElections")
      title = title.gsub("Afghanistan","#Afghanistan")
    end
    title = title.gsub("Afghan ","#Afghan ")
    title << " - #rtnewsAfg"
    puts "try to post ..."
    @graph.put_object(1477394625806542, "feed", :message => title,:link=>link)

  end

  def self.validate_google_redirect_url(link)
    link = link.gsub("https://www.google.com/url?q=","")
    link = link.split("&ct=ga&cd=")[0]
  end

  def self.parse_alert(url)
    @doc = nil
    begin
      @doc = Nokogiri::XML(open(url))
    rescue  Exception => e
      puts "nokogiri: exctpion while parsing the url : #{e.message}"
    end
    puts "URL: #{url}"

    # --> BEGIN PARSING
    @doc.search("entry").each do |node|
      # puts "\n"+@doc
      title = node.search("title").text
      link = node.css('link').map { |link| link['href'] }[0]
      check_hash(title, link)
    end # ~> END xpath
  end

end # @end module
