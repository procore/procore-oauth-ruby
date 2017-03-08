require 'sinatra/reloader' if development?
require 'pry' if development?
require 'json'

class App < Sinatra::Base
  set :sessions, true
  set :inline_templates, true
  set :logging, true

  configure :development do
    register Sinatra::Reloader
  end

  def client(token_method = :post)
    OAuth2::Client.new(
      ENV.fetch('PROCORE_CLIENT_ID', 'proauth-local'),
      ENV.fetch('PROCORE_CLIENT_SECRET', 'pleaseUseA4RealSecret.'),
      site: ENV.fetch('PROCORE_API_URL') {"http://localhost:3000"},
    )
  end

  def access_token
    OAuth2::AccessToken.new(client, session[:access_token], refresh_token: session[:refresh_token])
  end

  def redirect_uri
    ENV.fetch('PROCORE_OAUTH2_REDIRECT_URI') {'http://localhost:5000/callback'}
  end

  def authorized_api_request(path, query_string=nil)
    HTTParty.get("#{client.site}/#{path}?#{query_string}",
      headers: {
        'Authorization' => "Bearer #{session[:access_token]}",
        'Accept' => 'application/json',
      })
  end

  get '/' do
    erb :home
  end

  get '/sign_in' do
    redirect client.auth_code.authorize_url(redirect_uri: redirect_uri)
  end

  get '/sign_out' do
    session[:access_token] = nil
    session[:refresh_token] = nil
    erb :sign_out
  end

  get '/callback' do
    token = client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
    session[:access_token]  = token.token
    session[:refresh_token] = token.refresh_token
    erb :callback
  end

  get '/refresh' do
    token = access_token.refresh!
    session[:access_token]  = token.token
    session[:refresh_token] = token.refresh_token
    erb :refresh
  end

  get '/api/*' do
    result = authorized_api_request(params[:splat].join('/'), request.query_string)
    json JSON.parse(result.body)
  end



end


__END__

@@layout
<!doctype html>
<html class="no-js" lang="">
    <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
      <title>Oauth Sample Client</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="bootstrap.min.css" media="all" charset="utf-8">
      <% if session[:access_token] %>
        <script type="text/javascript">
          var apiUrl = '<%= "#{ENV['PROCORE_API_URL']}" %>'
          var authHeader = 'Bearer <%= session[:access_token] %>'
        </script>
        <!-- <script src="xmlhttp_request_example.js" charset="utf-8"></script> -->
        <script src="fetch_example.js" charset="utf-8"></script>
      <% end %>
    </head>
    <body>
      <div class="container">
        <div class="page-header clearfix">
          <h3 class="text-muted">Procore Oauth Client App</h3>
        </div>
        <div>
          <%= yield %>
        </div>
      </div>
    </body>
</html>


@@callback
<script type="text/javascript">
  localStorage.setItem('accessToken', '<%= session[:access_token] %>')
  localStorage.setItem('refreshToken', '<%= session[:refresh_token] %>')
  localStorage.setItem('apiUrl', '<%= ENV['PROCORE_API_URL'] %>')
  window.location = "/";
</script>


@@refresh
<script type="text/javascript">
  localStorage.setItem('accessToken', '<%= session[:access_token] %>')
  localStorage.removeItem('refreshToken')
  window.location = "/";
</script>


@@sign_out
<script type="text/javascript">
  console.log('signing out');
  localStorage.removeItem('accessToken')
  localStorage.removeItem('refreshToken')
  window.location = "/";
</script>


@@home
<div class="grid">
  <% if session[:access_token] %>
    access token <pre><%= session[:access_token] %></pre>
    refresh token <pre><a href='/refresh'><%= session[:refresh_token] %></a></pre>
    <a href='/sign_out' class='button btn btn-large btn-block btn-warning'>Sign Out</a>
    <br>
    <fieldset>
      <legend>Initate a CORS api request from this browser</legend>
      <%= client.site %>/vapid/companies:
      <pre  id='api-log'>
        <code class='lang-js'></code>
      </pre>
    </fieldset>
    <fieldset>
      <legend>Initiate an authorized api calls from server:</legend>
      <ul class='list'>
        <li>
          <a href='/api/vapid/companies'>/api/vapid/companies</a>
        </li>
        <li>
          <a href='/api/oauth/token/info'>/api/oauth/tokens/info</a>
        </li>
      </ul>
    </fieldset>
  <% else %>
    <a href='/sign_in' class='button btn btn-large btn-block btn-primary'>Sign In</a>
  <% end %>
</div>
