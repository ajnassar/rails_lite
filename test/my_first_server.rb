require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8080

server.mount_proc '/' do |req, res|
  res['Content-Type'] = 'text/text'
  res.body = req.path_info
  p req

end

trap('INT') { server.shutdown }
server.start