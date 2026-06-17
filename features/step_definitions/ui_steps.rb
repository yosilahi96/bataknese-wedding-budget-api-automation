def ensure_capybara!
  return if defined?(Capybara)

  require "capybara/cucumber"
  require "selenium-webdriver"

  Capybara.default_max_wait_time = ENV.fetch("DEFAULT_TIMEOUT", "10").to_i

  browser = ENV.fetch("BROWSER", "chrome").to_sym
  headless = ENV.fetch("HEADLESS", "true") == "true"

  Capybara.register_driver :selenium do |app|
    options =
      case browser
      when :firefox
        Selenium::WebDriver::Firefox::Options.new
      else
        Selenium::WebDriver::Chrome::Options.new
      end

    options.add_argument("--headless=new") if headless && browser == :chrome
    options.add_argument("-headless") if headless && browser == :firefox
    options.add_argument("--window-size=1440,900") if browser == :chrome

    Capybara::Selenium::Driver.new(app, browser: browser, options: options)
  end

  Capybara.default_driver = :selenium
  Capybara.javascript_driver = :selenium
end

When("I visit {string}") do |url|
  ensure_capybara!
  visit(url)
end

Then("the page should contain {string}") do |text|
  ensure_capybara!
  expect(page).to have_content(text)
end
