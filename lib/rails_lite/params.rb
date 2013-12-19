require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}
    @params.merge!(route_params)
    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    key_values = URI.decode_www_form(www_encoded_form)
    constructed_hash = []
    p key_values
    key_values.each do |key, value|
      constructed_hash << "'#{key}' => '#{value.to_s}'"
    end
    eval("{".concat(constructed_hash.join(", ")).concat("}"))
  end

  def parse_key(key)

  end
end
