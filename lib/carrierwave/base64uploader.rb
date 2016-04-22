module CarrierWave
  module Base64Uploader
    # https://gist.github.com/hilotter/6a4c356499b55e8eaf9a/
    def base64_conversion(uri_str, filename = 'base64')
      image_data = split_base64(uri_str)
      image_data_string = image_data[:data]
      image_data_binary = Base64.decode64(image_data_string)

      temp_img_file = Tempfile.new(filename)
      temp_img_file.binmode
      temp_img_file << image_data_binary
      temp_img_file.rewind

      img_params = {:filename => "#{filename}", :type => image_data[:type], :tempfile => temp_img_file}
      ActionDispatch::Http::UploadedFile.new(img_params)
    end

    def split_base64(uri_str)
      # uri_str.match(%r{data:(.*?);(.*?),(.*)$})
      a = uri_str.index(/^data:/)
      b = uri_str.index(/;/, a + 1) if a >= 0
      c = uri_str.index(/,/, b + 1) if b >= 0
      if a >= 0 && b >= 0 && c >= 0
        uri = Hash.new
        uri[:type] = uri_str[a + 5, b - a - 5]
        uri[:encoder] = uri_str[b + 1, c - b - 1]
        uri[:data] = uri_str[c + 1, uri_str.length - c - 1]
        uri[:extension] = uri[:type].split('/')[1]
        return uri
      else
        return nil
      end
    end
  end
end
