module Hooksler
  module Trello
    module SlackFormatter

      class Helper
        attr_reader :data
        def initialize(data)
          @data = data
        end

        def text
          data['action']['data']['text']
        end

        def board
          data['action']['data']['board']['name']
        end

        def user
          data['action']['memberCreator']['fullName']
        end

        def url
          data['model']['url']
        end

        def color
          data['model']['prefs']['backgroundColor']
        end
      end

      def for_trello(message)
        helper = Helper.new(message.raw)
        {
            text: helper.text.nil? ? nil : message.message,
            icon_url: 'https://slack.global.ssl.fastly.net/010d/img/services/trello_48.png',
            channel: self.channel,
            username: (message.user || self.username),
            attachments: [{
                fallback: message.message,
                color: helper.color,
                fields: [
                    {
                        title: '',
                        value: helper.text || message.message,
                        short: false
                    }, {
                         title: I18n.t('trello.slack.user', default: 'User'),
                         value: helper.user,
                         short: true
                    }, {
                        title: I18n.t('trello.slack.link', default: 'Link'),
                        value: I18n.t('trello.slack.go', default: '<%{url}|%{board}>', url: helper.url, board: helper.board),
                        short: true
                    }
                ]
            }]
        }
      end
    end
  end
end

if autoload?(:'Hooksler::Slack::Output') || defined?(Hooksler::Slack::Output)
  Hooksler::Slack::Output.send :include, Hooksler::Trello::SlackFormatter
end