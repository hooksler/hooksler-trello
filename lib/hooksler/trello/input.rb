require 'hashie'
require 'trello'
require 'trello/client'
require 'hooksler'
require 'hooksler/trello/slack_formatter'
require 'hooksler/trello/models'
require 'thread'

module Hooksler
  module Trello

    class Input
      extend Hooksler::Channel::Input
      include Models

      register :trello

      attr_accessor :public_key, :member_token, :board_id, :description

      def initialize(params)
        params = Hashie::Mash.new(params)
        @public_key = params.public_key
        @member_token = params.member_token
        @board_id = params.board_id
        @description = params.description
        @create_webhook = params.create

        @locale = (params.locale || :ru).to_sym

        @description = "Hook for #{@board_id}" unless @description
        if @create_webhook
          fail 'Public key undefined' unless @public_key
          fail 'Member token undefined' unless @member_token
          fail 'Board id undefined' unless @board_id

          @client = ::Trello::Client.new developer_public_key: @public_key, member_token: @member_token
        end
      end

      def route_defined(path)
        return unless @create_webhook

        delayed_proc = Proc.new do
          begin
            @webhook = ::Trello::Webhook.new
            @webhook.client = @client
            @webhook.description = @description
            @webhook.id_model = @board_id
            @webhook.callback_url = Hooksler::Router.host_name + path
            @webhook.save
          end
        end

        if defined?(EM) || defined?(Thin)
          EM::next_tick &delayed_proc
        else
          Thread.new do
            sleep 1
            delayed_proc.call
          end
        end

      end

      def load(request)
        return unless request.env['HTTP_X_TRELLO_WEBHOOK']

        payload = MultiJson.load(request.body.read)

        pre_locale = I18n.locale
        I18n.locale = @locale

        msg = build_message(payload) do |msg|
          msg.user = 'Trello'

          payload['action']['type'] =~ /^([a-z]*)/
          msg.message = dispatch msg, $1, payload['action']
        end

        I18n.locale = pre_locale
        msg unless msg.message.to_s.empty?
      end
    end
  end
end
