module Qbrick
  class Setting < ActiveRecord::Base

    class << self
      def [](key)
        find_by_key(key.to_s).try(:value) || ''
      end
    end
  end
end
