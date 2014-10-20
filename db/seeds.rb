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

# Add default settings

site_collection = Qbrick::SettingsCollection.find_or_create_by(collection_type: 'site')
page_collection = Qbrick::SettingsCollection.find_or_create_by(collection_type: 'page')
global_collection = Qbrick::SettingsCollection.find_or_create_by(collection_type: 'global')

settings = [
  { key: 'site_title', value: 'Default Site Title', settings_collection_id: site_collection.id },
  { key: 'site_description', value: 'Default Site Description', settings_collection_id: site_collection.id },
  { key: 'default_page_title', value: 'Default Page Title', settings_collection_id: page_collection.id },
  { key: 'default_page_description', value: 'Default Page Description', settings_collection_id: page_collection.id },
  { key: 'google_analytics_key', value: 'UA-xxxx-x', settings_collection_id: global_collection.id },
  { key: 'typekit_id', value: 'xxxxxxx', settings_collection_id: global_collection.id }
]

settings.each do |s|
  setting = Qbrick::Setting.find_or_create_by(key: s[:key])
  setting.update! s
end
