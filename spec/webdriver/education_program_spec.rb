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

  def fill_education_program_form(driver, edu_program_data)

    %i[vn_name training_program_code graduation_title graduation_diploma_vi].each do |name|
      driver.find_element(id: name.to_s).send_keys edu_program_data[name]
    end

    driver.find_element(id: 'institutionUuid').click
		driver.find_element(css: "[title='Khoa Công nghệ Nông nghiệp']").click

    driver.find_element(id: 'type').click
    driver.find_element(css: "[title='Chuẩn']").click
		
		driver.find_element(class: "ant-btn-primary").click
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

    context 'When create success training program' do
      before do
        custom_navigate driver, create_training_program_url
        fill_education_program_form driver, edu_program_data
      end

      let(:edu_program_data) do 
				{ vn_name: "Test tên ngành 1",
					training_program_code: "Test_MN_1",
					graduation_title: "Test danh hiệu tốt nghiệp 1",
					graduation_diploma_vi: "Tên văn bằng tốt nghiệp"
				}
			end

      it "Should redirect to training programs" do
        sleep 2
        screenshot driver, 'create_training_program_success', screenshot_dir_path

        expect(driver.current_url).to eql training_program_url
      end
    end

    context 'When show detail success training program' do
      before do
        custom_navigate driver, training_program_url
        sleep 2
      end


      it "Should redirect to detail training programs" do
        info_btn = driver.find_element css: '.ant-btn.ant-btn-primary.ant-btn-circle.ant-btn-sm.ant-btn-icon-only'
        detail_training_program_url = info_btn.find_element(xpath: "./..").attribute 'href'
        info_btn.click
        sleep 1
        screenshot driver, 'detail_training_program_success', screenshot_dir_path

        expect(driver.current_url).to eql detail_training_program_url
      end
    end

    context 'When edit training program' do
      before do
        custom_navigate driver, training_program_url
        sleep 2
        driver.find_element(css: '.anticon.anticon-edit').click
        sleep 2

        # Edit training program
        driver.find_element(id: 'vn_name').send_keys 'Editted'
        driver.find_element(class: "ant-btn-primary").click
      end

      it "Should alert message success training programs" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        message_box = driver.find_element css: '.ant-message-custom-content.ant-message-success'
        screenshot driver, 'edit_training_program_success', screenshot_dir_path

        expect(message_box.displayed?).to eql true
      end
    end

    context 'When delete success training program' do
      before do
        custom_navigate driver, training_program_url
        sleep 2
        driver.find_element(css: '.anticon.anticon-delete').click
        sleep 1
        driver.find_element(css: '.ant-btn.ant-btn-primary.ant-btn-sm').click
      end

      it "Should alert message success training programs" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        message_box = driver.find_element css: '.ant-message-custom-content.ant-message-success'

        screenshot driver, 'delete_training_program_success', screenshot_dir_path

        expect(message_box.displayed?).to eql true
      end
    end
  end    
end
