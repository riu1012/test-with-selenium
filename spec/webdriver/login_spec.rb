require "custom_helper"

RSpec.describe 'Selenium Webdriver Login' do
  let!(:driver) { Selenium::WebDriver.for :chrome }
  let(:wait_driver) { Selenium::WebDriver::Wait.new timeout: 5 }
  let(:login_url) { 'http://localhost:3000/uet/signin' }
  let(:screenshot_dir_path) { '/home/tran.thi.anh.thu/selenium/screenshot' }
  let(:error_title) { 'Đăng nhập không thành công' }
  let(:error_message) { 'Email hoặc mật khẩu không đúng' }
  
  def submit_form(driver, email, password)
    driver.find_element(id: 'normal_login_username').send_keys email
    driver.find_element(id: 'normal_login_password').send_keys password
    driver.find_element(id: 'normal_login_uetLogin').click
    screenshot driver, 'login', screenshot_dir_path
    driver.find_element(class: 'login-form-button').click
  end

  def get_banner_text(driver)
    wait_driver.until { driver.find_element(class: 'ant-notification-notice-description').displayed? }
    error_title = driver.find_element class: 'ant-notification-notice-message'
    error_message = driver.find_element class: 'ant-notification-notice-description'
    screenshot driver, 'login_error', screenshot_dir_path

    { error_title: error_title.text, error_message: error_message.text }
  end

  describe "Automating a login form" do
    before do
      setup_driver driver
      driver.navigate.to login_url
      submit_form driver, email, password
    end

    after { driver.quit }

    context 'When invalid email' do
      let(:email) { 'test@xyz.com' }
      let(:password) { '1' }

      it "Should correct error" do
        actual_error_text = get_banner_text driver

        expect(actual_error_text[:error_title]).to eql error_title
        expect(actual_error_text[:error_message]).to eql error_message
      end
    end

    context 'When invalid password' do
      let(:email) { 'admin' }
      let(:password) { 'wrongpassword' }

      it "Should correct error" do
        actual_error_text = get_banner_text driver
        expect(actual_error_text[:error_title]).to eql error_title
        expect(actual_error_text[:error_message]).to eql error_message
      end
    end

    context 'When valid email and password' do
      let(:email) { 'admin' }
      let(:password) { '1' }
      let(:dashboard_url) { 'http://localhost:3000/uet/statistic' }

      it "Should redirect to dashboard" do
        wait_driver.until { driver.find_element(class: 'ant-avatar-image').displayed? }
        sleep 2
        screenshot driver, 'login_success', screenshot_dir_path

        expect(driver.current_url).to eql dashboard_url
      end
    end
  end    
end
