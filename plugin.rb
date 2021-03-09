# frozen_string_literal: true

# name: discourse-disable-composer-messages
# about: Disable composer messages
# version: 0.0.13
# date: 9 March 2021
# authors: Neo
# url: https://github.com/unixneo/discourse-disable-composer-messages

PLUGIN_NAME = "discourse-disable-composer-messages"

enabled_site_setting :disable_composer_messages

after_initialize do
  ComposerMessagesController.class_eval do

    requires_login

    def index
        finder = ComposerMessagesFinder.new(current_user, params.slice(:composer_action, :topic_id, :post_id))
        if Sitesetting.disable_composer_messages?
          json = { composer_messages: "" }
        else
          json = { composer_messages: [finder.find].compact }
        end

        if params[:topic_id].present?  && !Sitesetting.disable_composer_messages?
          topic = Topic.where(id: params[:topic_id]).first
          if guardian.can_see?(topic)
            json[:extras] = { duplicate_lookup: TopicLink.duplicate_lookup(topic) }
          end
        end
          render_json_dump(json, rest_serializer: true)
    end
  end
end          

