require 'json'
require 'webrick'

class Session
  def initialize(req)
    @req = req
    @req.cookies.each do |cookie|
      next if cookie.name != '_rails_lite_app'

      @session_hash = JSON.parse(cookie.value)
    end
    @session_hash = {} if @session_hash.nil?
  end

  def [](key)
    @session_hash[key]
  end

  def []=(key, val)
    @session_hash[key] = val
  end

  def store_session(res)
    new_cookie = WEBrick::Cookie.new('_rails_lite_app', @session_hash.to_json)
    res.cookies << new_cookie
  end
end
