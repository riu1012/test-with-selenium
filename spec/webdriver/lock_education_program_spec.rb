require "custom_helper"

RSpec.describe 'Selenium Webdriver Login' do
  let!(:driver) { Selenium::WebDriver.for :chrome }
  let(:wait_driver) { Selenium::WebDriver::Wait.new timeout: 1 }
  let(:login_url) { 'http://112.137.129.236:3000/uet/signin' }
  let(:create_training_program_url) { 'http://112.137.129.236:3000/uet/training-programs/creation' }
  let(:training_program_url) { 'http://112.137.129.236:3000/uet/training-programs' }
  let(:screenshot_dir_path) { 'C:\Users\tanhi\Desktop\riu' }
  let(:email) { 'admin' }
  let(:password) { '1' }
  
  def submit_form(driver, email, password)
    driver.find_element(id: 'normal_login_username').send_keys email
    driver.find_element(id: 'normal_login_password').send_keys password
    driver.find_element(id: 'normal_login_uetLogin').click
    driver.find_element(class: 'login-form-button').click
  end

  describe "Automating program trainning" do
    before do
      setup_driver driver
      custom_navigate driver, login_url
      submit_form driver, email, password
      wait_driver.until { driver.find_element(class: 'ant-avatar-image').displayed? }
      sleep 1
    end

    after { driver.quit }

    context 'When lock success training program' do
      before do
        custom_navigate driver, training_program_url
        sleep 2
      end

      it "Should correct message" do
        info_btn = driver.find_element(css: '.anticon.anticon-unlock').click
        sleep 2
        driver.find_element(xpath: '//button[@class="ant-btn ant-btn-primary ant-btn-sm"]/span[text()]').click
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'lock_training_program_success', screenshot_dir_path

        expect(success_message).to eql 'Đã khóa chương trình đào tạo'
      end
    end

    context 'When unlock success training program' do
        before do
          custom_navigate driver, training_program_url
          sleep 2
        end
  
  
        it "Should correct message" do
          info_btn = driver.find_element(css: '.anticon.anticon-lock').click
          sleep 2
          driver.find_element(xpath: '//button[@class="ant-btn ant-btn-primary ant-btn-sm"]/span[text()]').click
          wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
          success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text
  
          screenshot driver, 'unlock_training_program_success', screenshot_dir_path
  
          expect(success_message).to eql 'Đã mở khóa chương trình đào tạo'
        end
      end
  end    
end
