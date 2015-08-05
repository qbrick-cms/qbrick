# Add default qbrick brick types
brick_types = [
  { class_name: 'Qbrick::TextBrick', group: 'elements' },
  { class_name: 'Qbrick::LinkBrick', group: 'elements' },
  { class_name: 'Qbrick::VideoBrick', group: 'elements' },
  { class_name: 'Qbrick::AccordionBrick', group: 'elements' },
  { class_name: 'Qbrick::AccordionItemBrick', group: 'elements' },
  { class_name: 'Qbrick::TwoColumnBrick', group: 'layout_elements' },
  { class_name: 'Qbrick::SliderBrick', group: 'elements' },
  { class_name: 'Qbrick::ImageBrick', group: 'elements' },
  { class_name: 'Qbrick::PlaceholderBrick', group: 'elements' },
  { class_name: 'Qbrick::AnchorBrick', group: 'elements' },
  { class_name: 'Qbrick::AssetBrick', group: 'elements' }
]

brick_types.each do |bt|
  brick_type = Qbrick::BrickType.find_or_create_by(class_name: bt[:class_name])
  brick_type.update! bt
end

unless  Qbrick::Admin.any?
  Qbrick::Admin.create(email: 'admin@admin.com', password: 'change-me-soon!')
end
