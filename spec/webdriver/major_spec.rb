require "custom_helper"

RSpec.describe 'Selenium Learning Outcome' do
  let!(:driver) { Selenium::WebDriver.for :chrome }
  let(:wait_driver) { Selenium::WebDriver::Wait.new timeout: 1 }
  let(:login_url) { 'http://localhost:3000/uet/signin' }
  let(:major_list_url) { 'http://localhost:3000/uet/majors' }
  let(:screenshot_dir_path) { '/home/tran.thi.anh.thu/selenium/screenshot' }
  let(:email) { 'admin' }
  let(:password) { '1' }
  
  def submit_form(driver, email, password)
    driver.find_element(id: 'normal_login_username').send_keys email
    driver.find_element(id: 'normal_login_password').send_keys password
    driver.find_element(id: 'normal_login_uetLogin').click
    driver.find_element(class: 'login-form-button').click
  end

  def fill_major_form(driver, major_data)

    %i[form_in_modal_vn_name form_in_modal_en_name form_in_modal_code form_in_modal_level].each do |name|
      driver.find_element(id: name.to_s).send_keys major_data[name]
    end

		driver.find_element(xpath: '//button[@class="ant-btn ant-btn-primary"]/span[text()="Lưu"]').click
  end

  describe "Automating major" do
    before do
      setup_driver driver
      custom_navigate driver, login_url
      submit_form driver, email, password
      wait_driver.until { driver.find_element(class: 'ant-avatar-image').displayed? }
      sleep 1
    end

    after { driver.quit }

    context 'When create success major' do
      before do
        custom_navigate driver, major_list_url
        sleep 2
        driver.find_element(css: '.ant-btn.ant-btn-primary.ant-btn-circle.ant-btn-lg.ant-btn-icon-only.ant-btn-dangerous').click
        sleep 2
        fill_major_form driver, major_data
      end

      let(:major_data) do 
				{
          form_in_modal_vn_name: 'Test ngành',
          form_in_modal_en_name: 'Test major',
          form_in_modal_code: '98234324',
          form_in_modal_level: 'Test level'
        }
			end

      it "Should create success major" do
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'create_major_success', screenshot_dir_path

        expect(success_message).to eql 'Thành công'
      end
    end

    context 'When edit success major' do
      before do
        custom_navigate driver, major_list_url
        sleep 5
        driver.find_element(xpath: '//td[@class="ant-table-cell" and text()="98234324"]/..//button[@class="ant-btn ant-btn-primary"]').click
        sleep 2

        # Edit major
        input_xpath = '//div[@class="ant-modal-content"]//input[@id="form_in_modal_en_name"]'
        driver.find_element(xpath: input_xpath).clear
        driver.find_element(xpath: input_xpath).send_keys 'Test major edited'
        driver.find_element(xpath: '//div[@class="ant-modal-content"]//button[@class="ant-btn ant-btn-primary"]//span[text()="Lưu"]').click
      end

      it "Should alert message success major" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'edit_major_success', screenshot_dir_path

        expect(success_message).to eql 'Thành công'
      end
    end

    context 'When edit unsuccessfully major' do
      before do
        custom_navigate driver, major_list_url
        sleep 5
        driver.find_element(xpath: '//td[@class="ant-table-cell" and text()="98234324"]/..//button[@class="ant-btn ant-btn-primary"]').click
        sleep 2

        # Edit major
        input_xpath = '//div[@class="ant-modal-content"]//input[@id="form_in_modal_en_name"]'
        driver.find_element(xpath: input_xpath).clear
        driver.find_element(xpath: input_xpath).send_keys ''
        driver.find_element(xpath: '//div[@class="ant-modal-content"]//button[@class="ant-btn ant-btn-primary"]//span[text()="Lưu"]').click
      end

      it "Should not create major" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'edit_major_unsuccessfully', screenshot_dir_path

        expect(success_message).to eql 'Tạo không thành công'
      end
    end

    context 'When delete success major' do
      before do
        custom_navigate driver, major_list_url
        sleep 5
        driver.find_element(xpath: '//td[@class="ant-table-cell" and text()="98234324"]/..//button[@class="ant-btn ant-btn-primary ant-btn-dangerous"]').click
        sleep 2
        driver.find_element(xpath: '//div[@class="ant-popover ant-popconfirm ant-popover-placement-top "]//button[@class="ant-btn ant-btn-primary ant-btn-sm"]').click
      end

      it "Should alert message success delete major" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'delete_major_success', screenshot_dir_path

        expect(success_message).to eql 'Thành công'
      end
    end
  end    
end
