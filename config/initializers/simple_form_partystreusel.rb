module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups
    module Label_with_i
      # Name of the component method
      def label_with_i(wrapper_options = nil)
        label_options = merge_wrapper_options(label_html_options, wrapper_options)
        @builder.label(label_target, '<i></i>'.html_safe + label_text, label_options)
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Label_with_i)

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :'partystreusel', tag: 'p', class: 'form--horizontal', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'form__help-inline' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'form__help-block' }
  end

  config.wrappers :prepend, tag: 'div', class: 'control-group', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :append, tag: 'div', class: 'control-group', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :partystreusel_boolean, tag: 'p', class: 'form--horizontal', error_class: 'error' do |b|
    b.use :html5
    b.use :input
    b.use :label_with_i
    b.use :error, wrap_with: { tag: 'span', class: 'form__help-inline' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'form__help-block' }
  end

  config.default_wrapper = :partystreusel
  config.boolean_style = :inline
end
