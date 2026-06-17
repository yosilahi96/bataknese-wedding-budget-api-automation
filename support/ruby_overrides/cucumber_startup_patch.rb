events_dir = File.expand_path(
  "../../vendor/bundle/ruby/4.0.0/gems/cucumber-9.2.1/lib/cucumber/events",
  __dir__
)

if Dir.exist?(events_dir)
  Dir[File.join(events_dir, "*.rb")].sort.each { |file| require file }
end
