RailsSettings::Settings.table_name = 'qbrick_settings'

module Qbrick
  class Settings < ::RailsSettings::CachedSettings
    scope :ordered, -> { order :var }
    DIVIDER = '.'
    alias_attribute :key, :var

    def slug
      var.to_s.gsub(/\W+/, '_')
    end

    def partial_name
      name = value.class.name.underscore.gsub(/\W+/, '_')
      case name
      when /(false|true)_class/
        'boolean'
      else
        name
      end
    end

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

      def hierarchy(starting_with = nil)
        result = {}.with_indifferent_access
        all_object_hash(starting_with).each_pair do |key, setting|
          build_hierarchy result, key, setting
        end

        result
      end

      def build_hierarchy(result_hash, key, setting)
        prefix = nil
        if key.is_a? Array
          prefix = key.shift
          key = key.last
        end

        namespaces = key.present? ? key.split(DIVIDER) : []
        if !namespaces.many? || namespaces.first.blank?
          result_hash[key] ||= {}.with_indifferent_access
          result_hash[key]['_value'] = setting
          result_hash[key]['_path'] = [prefix, key].compact.join DIVIDER
          return result_hash
        end

        namespace = namespaces.shift
        result_hash[namespace] ||= {}.with_indifferent_access
        build_hierarchy result_hash[namespace], [[prefix, namespace].compact.join(DIVIDER), namespaces.join(DIVIDER)], setting

        result_hash
      end
    end
  end
end
