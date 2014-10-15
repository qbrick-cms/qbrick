module Qbrick
  class Setting < ActiveRecord::Base

    belongs_to :settings_collection

    default_scope { order('id ASC') }

    class << self
      def [](key)
        find_by_key(key.to_s).try(:value) || ''
      end
    end
  end
end
