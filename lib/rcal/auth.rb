require 'googleauth'
require 'googleauth/stores/redis_token_store'
require 'google/apis/calendar_v3'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
user_id = ...
scope = 'https://www.googleapis.com/auth/calendar'
client_id = Google::Auth::ClientId.from_file('auth_creds.json')
token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

# credentials = token_store.load(user_id)

credentials = authorizer.get_credentials(user_id)
# p credentials
if credentials.nil?
  url = authorizer.get_authorization_url(base_url: OOB_URI)
  puts "Open #{url} in your browser and enter the resulting code:"
  code = gets
  credentials = authorizer.get_and_store_credentials_from_code(
    user_id: user_id, code: code, base_url: OOB_URI
  )
  # p credentials
end

# Calendar = Google::Apis::CalendarV3
calendar = Google::Apis::CalendarV3::CalendarService.new
calendar.authorization = credentials
calendar_id = 'primary'
response = calendar.list_events(calendar_id,
                                max_results: 10,
                                single_events: true,
                                order_by: 'startTime',
                                time_min: Time.now.iso8601)

p response
