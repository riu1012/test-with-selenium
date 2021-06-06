require "custom_helper"

RSpec.describe 'Selenium Cource' do
  let!(:driver) { Selenium::WebDriver.for :chrome }
  let(:wait_driver) { Selenium::WebDriver::Wait.new timeout: 1 }
  let(:login_url) { 'http://localhost:3000/uet/signin' }
  let(:cources_list_url) { 'http://localhost:3000/uet/courses' }
  let(:screenshot_dir_path) { '/home/tran.thi.anh.thu/selenium/screenshot' }
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

    after { driver.quit }

    context 'When create success cource' do
      before do
        custom_navigate driver, cources_list_url
        sleep 2
        driver.find_element(css: '.ant-btn.ant-btn-primary.ant-btn-circle.ant-btn-icon-only.ant-btn-dangerous').click
        sleep 2
        fill_cource_form driver, cource_data
      end

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

    context 'When create allspace cource' do
      before do
        custom_navigate driver, cources_list_url
        sleep 2
        driver.find_element(css: '.ant-btn.ant-btn-primary.ant-btn-circle.ant-btn-icon-only.ant-btn-dangerous').click
        sleep 2
        fill_cource_form driver, cource_data
        sleep 2
      end

      let(:cource_data) do 
				{ course_name_vi: "              ",
					course_code: "Test_Cource_Code_2",
          credits: 3
				}
			end

      it "Should create unnsuccess cources" do
        errors_message = {
          course_name_vi: driver.find_element(xpath: '//input[@id="course_name_vi"]//ancestor::div[@class="ant-col ant-col-14 ant-col-offset-1 ant-form-item-control"]//div[@class="ant-form-item-explain ant-form-item-explain-error"]//div[@role="alert"]').text
        }

        expected_error_message = {
          course_name_vi: 'Tên học phần không được bỏ trống'
        }
        screenshot driver, 'create_cource_success', screenshot_dir_path

        expect(expected_error_message).to eql errors_message
      end
    end

    context 'When edit success cource' do
      before do
        custom_navigate driver, cources_list_url
        sleep 5
        driver.find_element(id: 'advanced_search_course_code').send_keys 'Test_Cource_Code_1'
        sleep 2
        driver.find_element(xpath: '//span[text()]//ancestor::button[@class="ant-btn ant-btn-primary"]').click
        sleep 5
        driver.find_element(xpath: '//td[text() = "Test_Cource_Code_1"]/..//span[text()="Sửa"]//ancestor::a').click
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
        driver.find_element(id: 'advanced_search_course_code').send_keys 'Test_Cource_Code_1'
        sleep 2
        driver.find_element(xpath: '//span[text()]//ancestor::button[@class="ant-btn ant-btn-primary"]').click
        sleep 5
        driver.find_element(xpath: '//td[text() = "Test_Cource_Code_1"]/..//span[text()="Xóa"]//ancestor::a').click
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
