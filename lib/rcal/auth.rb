require 'googleauth'
require 'googleauth/stores/redis_token_store'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
user_id = 'bob'
scope = 'https://www.googleapis.com/auth/drive'
client_id = Google::Auth::ClientId.from_file('auth_creds.json')
token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

credentials = authorizer.get_credentials(user_id)
if credentials.nil?
  url = authorizer.get_authorization_url(base_url: OOB_URI)
  puts "Open #{url} in your browser and enter the resulting code:"
  code = gets
  credentials = authorizer.get_and_store_credentials_from_code(
    user_id: user_id, code: code, base_url: OOB_URI
  )
  p credentials
end
