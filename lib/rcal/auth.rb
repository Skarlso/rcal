require 'googleauth'
require 'googleauth/stores/redis_token_store'

module RCal
  class AuthModule
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    CREDENTIALS_PATH = File.join(Dir.home, '.credentials', 'calendar_creds.yaml').freeze
    def initialize(store)
      @user_id = 'skarlso'
      @scope = 'https://www.googleapis.com/auth/calendar'
      @client_id = Google::Auth::ClientId.from_file('auth_creds.json')
      case store
      when 'redis'
        @token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
      when 'file'
        FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
        @token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      else
        raise "Invalid store. Please use one of the following: 'file', 'redis'"
      end
      @authorizer = Google::Auth::UserAuthorizer.new(@client_id, @scope, @token_store)
    end

    def credentials
      credentials = @authorizer.get_credentials(@user_id)
      # p credentials
      if credentials.nil?
        url = @authorizer.get_authorization_url(base_url: OOB_URI)
        puts "Open #{url} in your browser and enter the resulting code:"
        STDOUT.flush
        code = STDIN.gets
        credentials = @authorizer.get_and_store_credentials_from_code(
          user_id: @user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end
  end
end
