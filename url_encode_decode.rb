module EncodeDecode

  def self.encode(url)
    encoded_url = nil
    headers = {"|_1rt"=>"http://www.", "|_2rt"=>"https://www."}
    dotcom = ".com/"
    dotcome_enc = "|_|"
    headers.each do |k,v|
      if url.include? v
        encoded_url = url.gsub(v,k)
        if encoded_url.include? dotcom
          encoded_url = encoded_url.gsub(dotcom,dotcome_enc)
        end
      end
    end #@end each
    if encoded_url.nil?
      url
    else
      encoded_url
    end

  end # @end def

  def self.decode(url)
    decoded_url = nil
    headers = {"|_1rt"=>"http://www.", "|_2rt"=>"https://www."}
    dotcom = ".com/"
    dotcome_enc = "|_|"
    headers.each do |k,v|
      if url.include? k
        decoded_url = url.gsub(k,v)
        if decoded_url.include? dotcome_enc
          decoded_url = decoded_url.gsub(dotcome_enc,dotcom)
        end
      end
    end # @end each
    if decoded_url.nil?
      url
    else
      decoded_url
    end
  end # @end def

end # @end module
