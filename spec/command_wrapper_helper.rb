require 'active_support/all'

[:rails, :rake].each do |command|
  define_method command do |task, options = nil|
    Dir.chdir test_app_path do
      # this is commented bc the output is annoying and not useful imho
      # if you cant provide a reason to keep this i'll delete
      # dbg_comment "cd #{test_app_path}"
      reload_application_gemfile
      `bundle exec "#{command} #{task}"`
    end
  end
end

# def dbg_comment(msg)
#   puts " # #{ts} - #{msg}"
# end

# def ts
#   Time.now.strftime('%H:%M:%S')
# end
