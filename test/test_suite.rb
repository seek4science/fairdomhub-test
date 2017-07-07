require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'

class TestSuite < Test::Unit::TestCase
  def setup
    @base_url = "https://fairdomhub.org/"
    @verification_errors = []
  end

  def teardown
    assert_equal [], @verification_errors
  end

  def test_suite
    puts "\nPlease provide the user name:"
    user_name = STDIN.gets.chomp
    puts "Please provide the password:"
    password = STDIN.noecho(&:gets).chomp
    for_firefox(user_name, password)
    for_chrome(user_name, password)
  end

  private

  def for_firefox(user_name, password)
    #caps = Selenium::WebDriver::Remote::Capabilities.firefox marionette: true
    #browser = Selenium::WebDriver.for :firefox, desired_capabilities: caps   
    
    browser = Selenium::WebDriver.for :firefox, marionette: true
    browser.manage().window.maximize()
    login(browser, user_name, password)
    get_page(browser)
    create_page(browser)
    post_page(browser)
    #association_box(browser)
    browser.quit
  end

  def for_chrome(user_name, password)
    driver_path = File.dirname(__FILE__) + "/../lib/drivers/chromedriver"
    Selenium::WebDriver::Chrome.driver_path = driver_path
    browser = Selenium::WebDriver.for :chrome
    browser.manage().window.maximize()
    login(browser, user_name, password)
    get_page(browser)
    create_page(browser)
    post_page(browser)
    #association_box(browser)
    browser.quit
  end

  def association_box(browser)
    browser.get(@base_url + "/assays/new?class=experimental")    
    assert browser.find_element(:xpath, "//form[@id='new_assay']/div[11]/div").text == "Data files"
    browser.find_element(:xpath, "//form[@id='new_assay']/div[11]/div").click
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until { browser.find_element(:id, "possible_data_files").displayed? }
    Selenium::WebDriver::Support::Select.new(browser.find_element(:id, "possible_data_files")).select_by(:text, "3' or Whole Gene Expression Array Template (Affymetrix)")
    assert browser.find_element(:css, "ul.related_asset_list > li").text == "3' or Whole Gene Expression Array Template (Affymetrix)  [remove]"
    browser.find_element(:link, "remove").click
    assert_equal "None", browser.find_element(:id, "data_file_to_list").text
    browser.find_element(:id, "include_other_project_data_files").click
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until { browser.find_element(:id, "possible_data_files").displayed? }
    Selenium::WebDriver::Support::Select.new(browser.find_element(:id, "possible_data_files")).select_by(:text, "090714 chemostat overview fluxes & quinones wt")
    assert_equal "090714 chemostat overview fluxes & quinones wt  [remove]", browser.find_element(:css, "ul.related_asset_list > li").text
  end

  def post_page(browser)
    simulate_jws browser
  end

  def simulate_jws(browser)
    browser.get @base_url + "models/144/simulate?version=8&constraint_based=1"
    #simulate_link = browser.find_element(:link_text, 'Simulate Model on JWS')
    #simulate_link.click
    wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
    wait.until { browser.find_element(:id => "jws_simulator_wrapper") }
  end

  def get_page(browser)
    #homepage
    browser.get @base_url
    assert_equal('The FAIRDOMHub',browser.title)

    #yellow pages
    browser.get @base_url + "programmes"
    assert_equal('Programmes',browser.title)
    browser.get @base_url + "programmes/1"
    assert_equal('SysMO',browser.title)
    browser.get @base_url + "people"
    assert_equal('People',browser.title)
    browser.get @base_url + "people/372"
    assert_equal('Quyen Nguyen',browser.title)
    browser.get @base_url + "projects"
    assert_equal('Projects',browser.title)
    browser.get @base_url + "projects/19"
    assert_equal('FAIRDOM',browser.title)
    browser.get @base_url + "institutions"
    assert_equal('Institutions',browser.title)
    browser.get @base_url + "institutions/7"
    assert_equal('Heidelberg Institute for Theoretical Studies (HITS gGmbH)',browser.title)

    #isa
    browser.get @base_url + "investigations"
    assert_equal('Investigations',browser.title)
    browser.get @base_url + "investigations/56"
    assert_equal('Glucose metabolism in Plasmodium falciparum trophozoites',browser.title)
    browser.get @base_url + "studies"
    assert_equal('Studies',browser.title)
    browser.get @base_url + "studies/138"
    assert_equal('Model analysis',browser.title)
    browser.get @base_url + "assays"
    assert_equal('Assays',browser.title)
    browser.get @base_url + "assays/296"
    assert_equal('Supply-demand analysis',browser.title)

    #assets
    browser.get @base_url + "data_files"
    assert_equal('Data files',browser.title)
    browser.get @base_url + "data_files/1101"
    assert_equal('Template for proteomics (2D gel)',browser.title)
    browser.get @base_url + "data_files/1101/explore?version=1"
    assert_equal('Template for proteomics (2D gel)',browser.title)
    browser.get @base_url + "models"
    assert_equal('Models',browser.title)
    browser.get @base_url + "models/138"
    assert_equal('Kinetic model for incubation (penkler2)',browser.title)
    browser.get @base_url + "sops"
    assert_equal('SOPs',browser.title)
    browser.get @base_url + "sops/203"
    assert_equal('Validation experiments',browser.title)
    browser.get @base_url + "publications"
    assert_equal('Publications',browser.title)
    browser.get @base_url + "publications/300"
    assert_equal('FAIRDOMHub: a repository and collaboration environment for sharing systems biology research',browser.title)

    #biosamples
    browser.get @base_url + "organisms"
    assert_equal('Organisms',browser.title)
    browser.get @base_url + "organisms/1933753700"
    assert_equal('Acidithiobacillus caldus',browser.title)
    browser.get @base_url + "sample_types"
    assert_equal('The FAIRDOMHub',browser.title)
    browser.get @base_url + "sample_types/2"
    assert_equal('YEAST_chemostat_steady_state_culture',browser.title)    

    #activities
    browser.get @base_url + "presentations"
    assert_equal('Presentations',browser.title)
    browser.get @base_url + "presentations/52"
    assert_equal('Seek new and upcoming features, Pals meeting in Heidelberg 2012',browser.title)
    browser.get @base_url + "presentations/52/content_blobs/2149/view_pdf_content"
    assert_equal('The FAIRDOMHub: Viewing SeekNewFeaturesPalsParis2013.odp',browser.title)
    browser.get @base_url + "events"
    assert_equal('Events',browser.title)
    browser.get @base_url + "events/26"
    assert_equal('1st EraSysApp PALs meeting',browser.title)

    #tags
    browser.get @base_url + "tags/"
    assert_equal('The FAIRDOMHub',browser.title)
    browser.get @base_url + "tags/19"
    assert_equal('The FAIRDOMHub',browser.title)
  end

  def login(browser, user_name, password)
    browser.get @base_url + "login"
    user_elelment = browser.find_element(:id, 'login')
    user_elelment.send_keys user_name
    password_element = browser.find_element(:id, 'password')
    password_element.send_keys password
    login_element = browser.find_element(:id, 'login_button')
    login_element.submit
    wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
    wait.until { browser.find_element(:id => "user-menu") }
  end

  def create_page(browser)
    #assets
    browser.get @base_url + "data_files/new"
    assert_not_nil browser.find_element(:id, 'data_file_title')
    browser.get @base_url + "models/new"
    assert_not_nil browser.find_element(:id, 'model_title')
    browser.get @base_url + "sops/new"
    assert_not_nil browser.find_element(:id, 'sop_title')
    browser.get @base_url + "publications/new"
    assert_not_nil browser.find_element(:id, 'protocol')

    #biosamples
    browser.get @base_url + "strains/new"
    assert_not_nil browser.find_element(:id, 'strain_title')
    #browser.get @base_url + "specimens/new"
    #assert_not_nil browser.find_element(:id, 'specimen_title')
    #browser.get @base_url + "samples/new"
    #assert_not_nil browser.find_element(:id, 'sample_title')

    #isa
    browser.get @base_url + "investigations/new"
    assert_not_nil browser.find_element(:id, 'investigation_title')
    browser.get @base_url + "studies/new"
    assert_not_nil browser.find_element(:id, 'study_title')
    browser.get @base_url + "assays/new?class=experimental"
    assert_not_nil browser.find_element(:id, 'assay_title')

    #activities
    browser.get @base_url + "presentations/new"
    assert_not_nil browser.find_element(:id, 'presentation_title')
    browser.get @base_url + "events/new"
    assert_not_nil browser.find_element(:id, 'event_title')
  end
end
