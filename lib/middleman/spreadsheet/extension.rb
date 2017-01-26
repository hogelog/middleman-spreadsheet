require 'middleman-core'

module Middleman
  module Spreadsheet
    class SpreadsheetNotFound < Exception; end
    class CredentialsNotFound < Exception; end

    class Extension < ::Middleman::Extension
      option :credentials, nil, 'Google API credentials'
      option :data_name, "spreadsheet", 'Spreadsheet key'
      option :spreadsheet_key, nil, 'Spreadsheet key'
      option :spreadsheet_url, nil, 'Spreadsheet url'
      option :spreadsheet_title, nil, 'Spreadsheet title'

      def initialize(app, options_hash={}, &block)
        super

        require "google_drive"
        require "sheet_wrap"

        session = drive_session(options)

        if options.spreadsheet_key
          spreadsheet = session.spreadsheet_by_key(options.spreadsheet_key)
        elsif options.spreadsheet_url
          spreadsheet = session.spreadsheet_by_url(options.spreadsheet_url)
        elsif options.spreadsheet_title
          spreadsheet = session.spreadsheet_by_title(options.spreadsheet_title)
        end

        raise SpreadsheetNotFound, "No spreadsheet specified" unless spreadsheet

        data = spreadsheet.worksheets.each_with_object({}) do |worksheet, hash|
          sheet_wrap = SheetWrap.wrap(worksheet)
          hash[sheet_wrap.title.to_sym] = sheet_wrap.rows.map(&:to_h)
        end
        @app.data.store(options.data_name.to_sym, data)
      end

      private

      def drive_session(options)
        if options.credentials
          credentials = Google::Auth::UserRefreshCredentials.new(
            client_id: options.credentials[:client_id],
            client_secret: options.credentials[:client_secret],
            scope: GoogleDrive::Session::DEFAULT_SCOPE,
            redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
          )
          if options.credentials[:refresh_token] || self.class.refresh_token
            credentials.refresh_token = options.credentials[:refresh_token] || self.class.refresh_token
            credentials.fetch_access_token!
          else
            STDERR.puts  "1. Open this page:\n#{credentials.authorization_uri}"
            STDERR.print "2. Enter the authorization code shown in the page: "
            credentials.code = STDIN.gets.chomp
            credentials.fetch_access_token!
            STDERR.puts  "3. Save refresh_token: #{credentials.refresh_token}"
            self.class.refresh_token = credentials.refresh_token
          end
          GoogleDrive::Session.from_credentials(credentials)
        elsif options.config
          GoogleDrive::Session.from_config(options.config)
        else
          raise CredentialsNotFound, "No credentials specified"
        end
      end

      def self.refresh_token=(token)
        @refresh_token = token
      end

      def self.refresh_token
        @refresh_token
      end
    end
  end
end
