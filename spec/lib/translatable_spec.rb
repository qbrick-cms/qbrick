require 'spec_helper'

describe Qbrick::Translatable do
  class Demo
    include Qbrick::Translatable
    translate :name
  end

  let :model do
    Demo.new
  end

  describe 'normal locale' do
    around(:each) do |example|
      I18n.with_locale(:en) { example.run }
    end

    describe '.translate' do
      it 'defines a getter for each attribute' do
        expect(model).to respond_to(:name)
      end

      it 'defines a setter for each attributes' do
        expect(model).to respond_to(:name=)
      end
    end

    describe '.locale_attr' do
      it 'returns a suffixed attribute name' do
        expect(Demo.locale_attr('text')).to eq('text_en')
      end
    end

    describe '#locale_attr' do
      it 'returns a suffixed attribute name' do
        expect(model.locale_attr('text')).to eq('text_en')
      end
    end

    describe 'translated attributes' do
      it 'delegates the getter to the suffixed attribute' do
        expect(model).to receive(:name_en).and_return('John')
        expect(model.name).to eq('John')
      end

      it 'delegates the setter to the suffixed attribute' do
        expect(model).to receive(:name_en=).with('Johnny')
        model.name = 'Johnny'
      end

      context 'dynamic methods' do
        it 'delegates boolean accessors' do
          expect(model).to receive(:name_en?)
          model.name?
        end

        it 'delegates simple dynamic finders' do
          expect(Demo).to receive(:find_by_name_en).with('Max')
          Demo.find_by_name('Max')
        end
      end

      context 'when changing the locale' do
        around(:each) do |example|
          I18n.with_locale(:de) { example.run }
        end

        it 'delegates the getter to current locale' do
          expect(model).to receive(:name_de).and_return('Johannes')
          expect(model.name).to eq('Johannes')
        end

        it 'delegates the getter to current locale' do
          expect(model).to receive(:name_de=).with('Johannes')
          model.name = 'Johannes'
        end
      end
    end
  end

  describe 'country specific locale' do
    around(:each) do |example|
      available_locales_backup = I18n.available_locales.deep_dup
      I18n.available_locales = [:de, 'de-CH', :en]
      I18n.with_locale('de-CH') { example.run }
      I18n.available_locales = available_locales_backup
    end

    describe '.translate' do
      it 'defines a getter for each attribute' do
        expect(model).to respond_to(:name)
      end

      it 'defines a setter for each attributes' do
        expect(model).to respond_to(:name=)
      end
    end

    describe '.locale_attr' do
      it 'returns a suffixed attribute name' do
        expect(Demo.locale_attr('text')).to eq('text_de_ch')
      end
    end

    describe '#locale_attr' do
      it 'returns a suffixed attribute name' do
        expect(Demo.locale_attr('text')).to eq('text_de_ch')
      end
    end

    describe 'translated attributes' do
      it 'delegates the getter to the suffixed attribute' do
        expect(model).to receive(:name_de_ch).and_return('John')
        expect(model.name).to eq('John')
      end

      it 'delegates the setter to the suffixed attribute' do
        expect(model).to receive(:name_de_ch=).with('Johnny')
        model.name = 'Johnny'
      end

      context 'dynamic methods' do
        it 'delegates boolean accessors' do
          expect(model).to receive(:name_de_ch?)
          model.name?
        end

        it 'delegates simple dynamic finders' do
          expect(Demo).to receive(:find_by_name_de_ch).with('Max')
          Demo.find_by_name('Max')
        end
      end

      context 'when changing the locale' do
        # outer describe block encapsulates with 'with_locale' and will set correct locale again!
        before(:each) { I18n.locale = :de }

        it 'delegates the getter to current locale' do
          expect(model).to receive(:name_de).and_return('Johannes')
          expect(model.name).to eq('Johannes')
        end

        it 'delegates the getter to current locale' do
          expect(model).to receive(:name_de=).with('Johannes')
          model.name = 'Johannes'
        end
      end
    end
  end
end
