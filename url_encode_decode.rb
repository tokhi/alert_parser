module EncodeDecode
  @encoded_url = nil
  @headers = {"|_1rt"=>"http://www.", "|_2rt"=>"https://www."}
  @dotcom = ".com/"
  @dotcome_enc = "|_|"
  @decoded_url = nil
  @http_headers = {"|_3rt"=>"http://", "|_4rt"=>"https://"}

  # def self.encode(url)
  #   @headers.each do |k,v|
  #     if url.include? v
  #       @encoded_url = url.gsub(v,k)
  #       if @encoded_url.include? @dotcom
  #         @encoded_url = @encoded_url.gsub(@dotcom,@dotcome_enc)
  #       end
  #     end
  #   end #@end each
  #   if @encoded_url.nil?
  #     @http_headers.each do |k,v|
  #       if url.include? v
  #         # puts "yeah exist"
  #         @encoded_url = url.gsub(v,k)

  #         if @encoded_url.include? @dotcom
  #           @encoded_url = @encoded_url.gsub(@dotcom,@dotcome_enc)
  #         end
  #       end

  #     end #@end @http_@headers.each
  #   end # if @encoded_url.nil

  #   if @encoded_url.nil?
  #     url
  #   else
  #     @encoded_url
  #   end

  # end # @end def



  # def self.decode(url)

    # @headers.each do |k,v|
    #   if url.include? k
    #     @decoded_url = url.gsub(k,v)
    #     if @decoded_url.include? @dotcome_enc
    #       @decoded_url = @decoded_url.gsub(@dotcome_enc,@dotcom)
    #     end
    #   end
    # end # @end each
    # if @decoded_url.nil?
    #   @http_@headers.each do |k,v|
    #     if url.include? k
    #       @decoded_url = url.gsub(k,v)
    #       if @decoded_url.include? @dotcome_enc
    #         @decoded_url = @decoded_url.gsub(@dotcome_enc,@dotcom)
    #       end
    #     end
    #   end # @end each
    # end # if @decoded_url
    # if @decoded_url.nil?
    #   url
    # else
    #   @decoded_url
    # end
  #   url
  # end # @end def


  def self.simple_encode(url)
  	url = [url].pack("u")
  end

  def self.simple_decode(url)
  	url = url.unpack("u")[0]
  end

end # @end module
