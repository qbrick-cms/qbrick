# TODO: the overwritten helper methods (or even the whole module here) can be removed
# if https://github.com/accessd/rails-settings-ui/issues/27 is solved
# Everything here is taken from:
# https://github.com/accessd/rails-settings-ui/blob/master/app/helpers/rails_settings_ui/settings_helper.rb
module Qbrick
  module Cms
    module SettingsHelper

      def qbrick_setting_field(setting_name, setting_value, all_settings)
        if !RailsSettingsUi.settings_klass.defaults.has_key?(setting_name.to_sym)
          message_for_default_value_missing
        elsif RailsSettingsUi.settings_displayed_as_select_tag.include?(setting_name.to_sym)
          settings_select_tag_field(setting_name, setting_value)
        elsif setting_value.is_a?(Array)
          settings_checkboxes_group_field(setting_name, all_settings)
        elsif [TrueClass, FalseClass].include?(setting_value.class)
          settings_checkbox_field(setting_name, setting_value)
        else
          settings_text_field(setting_name, setting_value, class: 'form-control')
        end
      end

      def settings_select_tag_field(setting_name, setting_value)
        default_setting_values = I18n.t("settings.attributes.#{setting_name}.labels", default: {}).map do |label, value|
          [label, value]
        end
        select_tag("settings[#{setting_name}]", options_for_select(default_setting_values, setting_value), class: 'form-control')
      end

      def settings_checkboxes_group_field(setting_name, all_settings)
        field = ''
        RailsSettingsUi.settings_klass.defaults[setting_name.to_sym].each do |value|
          checked = all_settings[setting_name.to_s].map(&:to_s).include?(value.to_s)
          field << check_box_tag("settings[#{setting_name}][#{value}]", nil, checked, style: 'margin: 0 10px;')
          field << label_tag("settings[#{setting_name}][#{value}]",
                             I18n.t("settings.attributes.#{setting_name}.labels.#{value}",
                                    default: value.to_s), style: 'display: inline-block;')
        end
        help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
        field << content_tag(:span, help_block_content, class: 'help-block') if help_block_content.presence
        field.html_safe
      end

      def settings_checkbox_field(setting_name, setting_value)
        help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
        fields = ''
        fields << hidden_field_tag("settings[#{setting_name}]", 'off').html_safe
        fields << check_box_tag("settings[#{setting_name}]", nil, setting_value).html_safe
        fields << content_tag(:span, help_block_content, class: 'help-block') if help_block_content.presence
        fields.html_safe
      end

      def settings_text_field(setting_name, setting_value, options = {})
        field = if setting_value.to_s.size > 30
                  text_area_tag("settings[#{setting_name}]", setting_value.to_s, options.merge(rows: 10))
                else
                  text_field_tag("settings[#{setting_name}]", setting_value.to_s, options)
                end

        help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
        field + (help_block_content.presence && content_tag(:span, help_block_content, class: 'help-block'))
      end

      def message_for_default_value_missing
        content_tag(:span, I18n.t("settings.errors.default_missing"), class: "label label-important")
      end
    end
  end
end
