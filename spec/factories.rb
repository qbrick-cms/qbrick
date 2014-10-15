FactoryGirl.define do
  sequence(:title) { |n| "English Title #{n}" }

  factory :page, class: 'Qbrick::Page' do |p|
    p.parent nil
    p.position 1
    p.title { FactoryGirl.generate(:title) }
    p.published 1
    p.body 'lorem ipsum'
    p.url ''
  end

  factory :text_brick, class: 'Qbrick::TextBrick' do |tb|
    tb.type 'Qbrick::TextBrick'
    tb.text 'DummyText'
  end

  factory :placeholder_brick, class: 'Qbrick::PlaceholderBrick' do |tb|
    tb.type 'Qbrick::PlaceholderBrick'
    tb.template_name 'foo'
  end

  factory :image_brick, class: 'Qbrick::ImageBrick' do |ib|
    ib.image File.open("#{Qbrick::Engine.root}/spec/dummy/app/assets/images/spec-image.png")
    ib.image_size 'gallery'
  end

  factory :asset, class: Qbrick::Asset do |a|
    a.file File.open("#{Qbrick::Engine.root}/spec/dummy/app/assets/images/spec-image.png")
  end
end
