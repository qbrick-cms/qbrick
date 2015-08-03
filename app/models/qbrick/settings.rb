RailsSettings::Settings.table_name = 'qbrick_settings'

module Qbrick
  class Settings < ::RailsSettings::CachedSettings
    DIVIDER = '.'

    def partial_name
      value.class.name.underscore.gsub(/\W+/, '_')
    end

    class << self
      def vars
        pluck :var
      end
      alias keys vars

      def get_all_objects(starting_with = nil)
        vars = thing_scoped
        vars = vars.where "var LIKE '#{starting_with}%'" if starting_with

        Hash[vars.map { |record| [record.var, record] }].with_indifferent_access
      end

      def hierarchy(starting_with = nil)
        result = {}.with_indifferent_access
        get_all_objects(starting_with).each_pair do |key, setting|
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
