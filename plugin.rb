# frozen_string_literal: true

# name: discourse-disable-composer-messages
# about: Disable composer messages
# version: 0.0.12
# date: 9 March 2021
# authors: Neo
# url: https://github.com/unixneo/discourse-disable-composer-messages

PLUGIN_NAME = "discourse-disable-composer-messages"

enabled_site_setting :disable_composer_messages

after_initialize do
  ComposerMessagesController.class_eval do

    requires_login

    def index
      return if Sitesetting.disable_composer_messages?
        finder = ComposerMessagesFinder.new(current_user, params.slice(:composer_action, :topic_id, :post_id))
        json = { composer_messages: [finder.find].compact }

        if params[:topic_id].present?
          topic = Topic.where(id: params[:topic_id]).first
          if guardian.can_see?(topic)
            json[:extras] = { duplicate_lookup: TopicLink.duplicate_lookup(topic) }
          end
        end
          render_json_dump(json, rest_serializer: true)
    end
  end
end          

