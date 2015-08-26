RailsSettings::Settings.table_name = 'qbrick_settings'

module Qbrick
  class Settings < ::RailsSettings::CachedSettings
    scope :ordered, -> { order :var }
    alias_attribute :key, :var

    class << self
      def vars
        pluck :var
      end
      alias keys vars

      def all_object_hash(starting_with = nil)
        vars = thing_scoped.ordered
        vars = vars.where "var LIKE '#{starting_with}%'" if starting_with

        Hash[vars.map { |record| [record.var, record] }].with_indifferent_access.tap do |result|
          @@defaults.slice(*(@@defaults.keys - result.keys)).each do |key, value|
            next if starting_with.present? && !key.start_with?(starting_with)

            result[key] = Qbrick::Settings.new var: key, value: value
          end
        end
      end
    end
  end
end
