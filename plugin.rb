# frozen_string_literal: true

# name: discourse-disable-composer-messages
# about: Disable composer messages
# version: 0.0.17
# date: 9 March 2021
# authors: Neo
# url: https://github.com/unixneo/discourse-disable-composer-messages

PLUGIN_NAME = "discourse-disable-composer-messages"

enabled_site_setting :disable_composer_messages

after_initialize do
  require_relative "./app/controllers/composer_messages_finder_controller.rb"
  require_relative "./app/controllers/similar_topics_controller.rb"
end          

