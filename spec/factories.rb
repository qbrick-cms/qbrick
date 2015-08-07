FactoryGirl.define do
  sequence(:title) { |n| "English Title #{n}" }

  factory :page, class: 'Qbrick::Page' do |p|
    p.parent nil
    p.position 1
    p.title { FactoryGirl.generate(:title) }
    p.published 1
    p.body 'lorem ipsum'
    p.page_type Qbrick::PageType::CONTENT
  end

  factory :root_page, parent: :page do |p|
    sequence(:title) { |n| "Root Title #{n}" }
    p.parent nil
    p.page_type Qbrick::PageType::NAVIGATION
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

  factory :admin, class: Qbrick::Admin do
    email 'test@test.com'
    password 'somel33tPW'
  end
end
