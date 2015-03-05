require 'spec_helper'

describe Qbrick::Searchable do
  context 'with missing includes' do
    it 'raises exteption when class does not include Qbrick::Bricklist' do
      expect do
        class Foo
          include Qbrick::Searchable
        end
      end.to raise_error(/needs Qbrick::BrickList to be included/)
    end
  end

  context 'with Bricklist included' do
    class SearchableDemo < ActiveRecord::Base
      include Qbrick::BrickList
    end

    context 'without postgresql' do
      it 'initializes scope' do
        expect(ActiveRecord::Base.connection.instance_values).not_to eq('postgresql')
        expect(SearchableDemo).to receive :scope
        SearchableDemo.class_eval do
          include Qbrick::Searchable
        end
      end
    end
  end
end
