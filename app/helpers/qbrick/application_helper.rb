require 'webpacker/helper'

module Qbrick
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      Qbrick.webpacker
    end
  end
end
