require "custom_helper"

RSpec.describe 'Selenium Learning Outcome' do
  let!(:driver) { Selenium::WebDriver.for :chrome }
  let(:wait_driver) { Selenium::WebDriver::Wait.new timeout: 1 }
  let(:login_url) { 'http://localhost:3000/uet/signin' }
  let(:learning_outcome_list_url) { 'http://localhost:3000/uet/learning-outcomes' }
  let(:screenshot_dir_path) { '/home/tran.thi.anh.thu/selenium/screenshot' }
  let(:email) { 'admin' }
  let(:password) { '1' }
  
  def submit_form(driver, email, password)
    driver.find_element(id: 'normal_login_username').send_keys email
    driver.find_element(id: 'normal_login_password').send_keys password
    driver.find_element(id: 'normal_login_uetLogin').click
    driver.find_element(class: 'login-form-button').click
  end

  def fill_learning_outcome_form(driver, learning_outcome_data)

    %i[dynamic_form_nest_item_locs_0_content].each do |name|
      driver.find_element(id: name.to_s).send_keys learning_outcome_data[name]
    end

    modal_create = driver.find_element(xpath: '//div[@class="ant-drawer ant-drawer-right ant-drawer-open"]')
    modal_create.find_element(xpath: '//input[@class="ant-select-selection-search-input"]//ancestor::div[@class="ant-form-item-control-input-content"]').click
		driver.find_element(css: "[title='Kiến thức']").click

		driver.find_element(xpath: '//button[@class="ant-btn ant-btn-primary"]/span[text()="Lưu"]').click
  end

  describe "Automating learning_outcome trainning" do
    before do
      setup_driver driver
      custom_navigate driver, login_url
      submit_form driver, email, password
      wait_driver.until { driver.find_element(class: 'ant-avatar-image').displayed? }
      sleep 1
    end

    after { driver.quit }

    context 'When create success learning outcome' do
      before do
        custom_navigate driver, learning_outcome_list_url
        sleep 2
        driver.find_element(css: '.ant-btn.ant-btn-primary.ant-btn-circle.ant-btn-lg.ant-btn-icon-only.ant-btn-dangerous').click
        sleep 2
        driver.find_element(xpath: '//div[@class="ant-drawer ant-drawer-right ant-drawer-open"]//button[@class="ant-btn ant-btn-dashed ant-btn-block"]//span[text()="Thêm CĐR"]').click
        sleep 2
        fill_learning_outcome_form driver, learning_outcome_data
      end

      let(:learning_outcome_data) do 
				{ dynamic_form_nest_item_locs_0_content: "Test chuẩn đầu ra" }
			end

      it "Should create success learning outcome" do
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'create_learning_outcome_success', screenshot_dir_path

        expect(success_message).to eql 'CĐR được thêm thành công'
      end
    end

    context 'When edit success learning_outcome' do
      before do
        custom_navigate driver, learning_outcome_list_url
        sleep 5
        driver.find_element(xpath: '//input[@placeholder="Tìm kiếm theo nội dung"]').send_keys 'Test chuẩn đầu ra'
        sleep 5
        driver.find_element(xpath: '//span[text()]//ancestor::button[@class="ant-btn ant-btn-primary"]').click
        sleep 2

        # Edit learning_outcome
        input_element = driver.find_element(xpath: '//div[@class="ant-modal-content"]//textarea[@id="form_in_modal_content"]')
        input_element.clear
        input_element.send_keys 'Test learning outcome editted'
        driver.find_element(xpath: '//div[@class="ant-modal-content"]//button[@class="ant-btn ant-btn-primary"]//span[text()="Cập nhật"]').click
      end

      it "Should alert message success learning outcomes" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'edit_learning_outcome_success', screenshot_dir_path

        expect(success_message).to eql 'Cập nhật CĐR thành công'
      end
    end

    context 'When delete success learning_outcome' do
      before do
        custom_navigate driver, learning_outcome_list_url
        sleep 5
        driver.find_element(xpath: '//input[@placeholder="Tìm kiếm theo nội dung"]').send_keys 'Test learning outcome editted'
        sleep 5
        driver.find_element(xpath: '//span[text()]//ancestor::button[@class="ant-btn ant-btn-primary ant-btn-dangerous"]').click
        sleep 2
        driver.find_element(xpath: '//div[@class="ant-popover ant-popconfirm ant-popover-placement-top "]//button[@class="ant-btn ant-btn-primary ant-btn-sm"]').click
      end

      it "Should alert message success delete learning outcome" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'delete_learning_outcome_success', screenshot_dir_path

        expect(success_message).to eql 'Xóa CĐR thành công'
      end
    end
  end    
end
