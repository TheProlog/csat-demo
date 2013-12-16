
task :cruise do
  system 'rake db:reset'
  system 'rake db:test:clone'
  system 'teaspoon -q -f tap_y | tapout pretty'
  system 'rake spec'

  system 'bin/rubocop -R -f s app spec'
  # system 'rake testoutdated'
end
