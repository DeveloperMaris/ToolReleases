module Jekyll
  module SignatureFilter
    def sparkle_signature(release_body)
      regex = /<!-- sparkle:edSignature="(?<signature>.*)" length="(?<length>.*)" -->/m
      match = release_body.match(regex)
      if match
          signature = match.named_captures["signature"]
      else
          signature = ""
      end
      signature
    end
  end
end

Liquid::Template.register_filter(Jekyll::SignatureFilter)
