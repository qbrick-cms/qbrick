Dummy::Application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do
    root "qbrick/pages#show"
  end
  mount Qbrick::Engine => "/"
end
