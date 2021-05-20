require "spec_helper"
require "selenium-webdriver"
require "rspec"
require "pry"

def screenshot(driver, name, path)
  driver.save_screenshot("#{path}\\#{name}_#{Time.now.to_i}.png")
end

def setup_driver(driver)
  driver.manage.window.move_to(0, 0)
  driver.manage.window.maximize
end

def custom_navigate(driver, url)
  driver.navigate.to url
end
