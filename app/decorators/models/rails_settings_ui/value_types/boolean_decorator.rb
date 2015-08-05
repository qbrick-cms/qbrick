# TODO: This file can be removed when
# https://github.com/accessd/rails-settings-ui/issues/27 is solved
# Everything here is taken from:
# https://raw.githubusercontent.com/accessd/rails-settings-ui/master/lib/rails-settings-ui/value_types/boolean.rb
RailsSettingsUi::ValueTypes::Boolean.class_eval do
  def cast
    self.value = value != 'off'
  end
end
