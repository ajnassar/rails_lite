require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params ||= Params.new(@req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    raise "Response Already Built" if @already_built_response
    @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, url)
    session.store_session(@res)
    @already_built_response = true
  end

  def render_content(body, type)
    raise "Response Already Built" if @already_built_response
    @res['Content-Type'] = type
    @res.body = body
    @already_built_response = true
  end

  def render(template_name)
    controller_name = self.class.name.underscore
    file_name = "views/#{controller_name}/#{template_name}.html.erb"
    file = File.read(file_name)
    template = ERB.new(file)
    session.store_session(@res)
    render_content(template.result(binding), "text/text")

  end

  def invoke_action(name)
  end
end
