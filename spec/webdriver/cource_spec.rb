require "custom_helper"

RSpec.describe 'Selenium Cource' do
  let!(:driver) { Selenium::WebDriver.for :chrome }
  let(:wait_driver) { Selenium::WebDriver::Wait.new timeout: 1 }
  let(:login_url) { 'http://112.137.129.236:3000/uet/signin' }
  let(:cources_list_url) { 'http://112.137.129.236:3000/uet/courses' }
  let(:screenshot_dir_path) { 'C:\Users\tanhi\Desktop\riu' }
  let(:email) { 'admin' }
  let(:password) { '1' }
  
  def submit_form(driver, email, password)
    driver.find_element(id: 'normal_login_username').send_keys email
    driver.find_element(id: 'normal_login_password').send_keys password
    driver.find_element(id: 'normal_login_uetLogin').click
    driver.find_element(class: 'login-form-button').click
  end

  def fill_cource_form(driver, cource_data)

    %i[course_name_vi course_code credits].each do |name|
      driver.find_element(id: name.to_s).send_keys cource_data[name]
    end

    driver.find_element(xpath: '//input[@id="institutionUuid"]/../span').click
		driver.find_element(css: "[title='Khoa Công nghệ Nông nghiệp']").click

		driver.find_element(xpath: '//div[@class="ant-modal-content"]//*[@class="ant-btn ant-btn-primary"]').click
  end

  describe "Automating cource trainning" do
    before do
      setup_driver driver
      custom_navigate driver, login_url
      submit_form driver, email, password
      wait_driver.until { driver.find_element(class: 'ant-avatar-image').displayed? }
      sleep 1
    end

    context 'When create success cource' do
      before do
        custom_navigate driver, cources_list_url
        sleep 2
        driver.find_element(css: '.ant-btn.ant-btn-primary.ant-btn-circle.ant-btn-icon-only.ant-btn-dangerous').click
        sleep 2
        fill_cource_form driver, cource_data
      end

      after { driver.quit }

      let(:cource_data) do 
				{ course_name_vi: "Test học phần 1",
					course_code: "Test_Cource_Code_1",
          credits: 3
				}
			end

      it "Should create success cources" do
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'create_cource_success', screenshot_dir_path

        expect(success_message).to eql 'Tạo mới học phần thành công'
      end
    end

    context 'When edit success cource' do
      before do
        custom_navigate driver, cources_list_url
        sleep 5
        driver.find_element(xpath: '//span[text() = "Sửa"]//ancestor::a').click
        sleep 2

        # Edit cource
        driver.find_element(id: 'form_in_modal_course_name_vi').send_keys 'Test cource editted'
        driver.find_element(xpath: '//div[@class="ant-modal-content"]//button[@class="ant-btn ant-btn-primary"]//span[text()="Cập nhật"]').click
      end

      it "Should alert message success cources" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'edit_cource_success', screenshot_dir_path

        expect(success_message).to eql 'Cập nhật thành công'
      end
    end

    context 'When delete success cource' do
      before do
        custom_navigate driver, cources_list_url
        sleep 5
        driver.find_element(xpath: '//span[text() = "Xoá"]//ancestor::a').click
        sleep 2
        driver.find_element(xpath: '//div[@class="ant-popover ant-popconfirm ant-popover-placement-top "]//button[@class="ant-btn ant-btn-primary ant-btn-sm"]').click
      end

      it "Should alert message success delete cource" do 
        wait_driver.until { driver.find_element(css: '.ant-message-custom-content.ant-message-success').displayed? }
        success_message = driver.find_element(xpath: '//div[@class="ant-message-custom-content ant-message-success"]/span[text()]').text

        screenshot driver, 'delete_cource_success', screenshot_dir_path

        expect(success_message).to eql 'Xóa học phần thành công'
      end
    end
  end    
end
