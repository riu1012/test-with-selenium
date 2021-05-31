require "custom_helper"

RSpec.describe 'Selenium Account' do
  let!(:driver) { Selenium::WebDriver.for :chrome }
  let(:wait_driver) { Selenium::WebDriver::Wait.new timeout: 1 }
  let(:login_url) { 'http://112.137.129.236:3000/uet/signin' }
  let(:account_list_url) { 'http://112.137.129.236:3000/uet/majors' }
  let(:account_creation_url) { 'http://112.137.129.236:3000/uet/creation/accounts' }
  let(:screenshot_dir_path) { 'C:\Users\tanhi\Desktop\riu' }
  let(:email) { 'admin' }
  let(:password) { '1' }
  
  def submit_form(driver, email, password)
    driver.find_element(id: 'normal_login_username').send_keys email
    driver.find_element(id: 'normal_login_password').send_keys password
    driver.find_element(id: 'normal_login_uetLogin').click
    driver.find_element(class: 'login-form-button').click
  end

  def fill_account_form(driver, account_data)

    %i[fullname vnu_mail password].each do |name|
      driver.find_element(id: name.to_s).send_keys account_data[name]
    end

    # Chọn giới tính
    driver.find_element(xpath: '//input[@name="radio-gender" and @value="Nam"]').click

    # Chọn đơn vị chuyên môn
    driver.find_element(xpath: '//input[@id="institution"]/../span').click
		driver.find_element(css: "[title='Khoa Công nghệ Nông nghiệp']").click

		driver.find_element(xpath: '//button[@class="ant-btn ant-btn-primary"]/span[text()="Thêm giảng viên"]').click
  end

  describe "Automating account" do
    before do
      setup_driver driver
      custom_navigate driver, login_url
      submit_form driver, email, password
      wait_driver.until { driver.find_element(class: 'ant-avatar-image').displayed? }
      sleep 1
    end

    after { driver.quit }

    context 'When create success account' do
      before do
        custom_navigate driver, account_creation_url
        sleep 2
        fill_account_form driver, account_data
      end

      let(:account_data) do 
				{
          fullname: 'Nguyễn Văn A',
          vnu_mail: 'test@vnu.edu.vn',
          password: '1'
        }
			end

      it "Should create success account" do
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'create_lecturer_account_success', screenshot_dir_path

        expect(success_message).to eql 'Tạo mới giảng viên thành công'
      end
    end

    context 'When valid data account' do
      before do
        custom_navigate driver, account_creation_url
        sleep 2
        driver.find_element(xpath: '//button[@class="ant-btn ant-btn-primary"]/span[text()="Thêm giảng viên"]').click
        sleep 2
      end

      it "Should do not create account" do
        errors_message = {
          name: driver.find_element(xpath: '//input[@id="fullname"]//ancestor::div[@class="ant-col ant-form-item-control"]//div[@class="ant-form-item-explain ant-form-item-explain-error"]//div[@role="alert"]').text,
          gender: driver.find_element(xpath: '//input[@name="radio-gender"]//ancestor::div[@class="ant-col ant-form-item-control"]//div[@class="ant-form-item-explain ant-form-item-explain-error"]//div[@role="alert"]').text,
          institution: driver.find_element(xpath: '//input[@id="institution"]//ancestor::div[@class="ant-col ant-form-item-control"]//div[@class="ant-form-item-explain ant-form-item-explain-error"]//div[@role="alert"]').text,
          gmail: driver.find_element(xpath: '//input[@id="vnu_mail"]//ancestor::div[@class="ant-col ant-form-item-control"]//div[@class="ant-form-item-explain ant-form-item-explain-error"]//div[@role="alert"]').text,
          password: driver.find_element(xpath: '//input[@id="password"]//ancestor::div[@class="ant-col ant-form-item-control"]//div[@class="ant-form-item-explain ant-form-item-explain-error"]//div[@role="alert"]').text
        }

        expected_error_message = {
          name: 'Tên giảng viên không được để trống',
          gender: 'Vui lòng chọn giới tính của giảng viên',
          institution: 'Chọn 1 đơn vị giảng viên làm việc',
          gmail: 'VNU mail không được để trống!',
          password: 'Mật khẩu không được để trống!'
        }

        screenshot driver, 'create_lecturer_account_blank_error', screenshot_dir_path

        expect(errors_message).to eql expected_error_message
      end
    end

    # context 'When create existed account' do
    #   before do
    #     custom_navigate driver, account_creation_url
    #     sleep 2
    #     fill_account_form driver, account_data
    #   end

    #   let(:account_data) do 
		# 		{
    #       fullname: 'Nguyễn Văn B',
    #       vnu_mail: 'test@vnu.edu.vn',
    #       password: '1'
    #     }
		# 	end

    #   it "Should do not create account" do
    #     wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
    #     error_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

    #     screenshot driver, 'create_lecturer_account_error', screenshot_dir_path

    #     expect(success_message).to eql 'Đã xảy ra lỗi'
    #   end
    # end
  end    
end
