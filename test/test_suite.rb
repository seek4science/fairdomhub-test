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
    browser = Selenium::WebDriver.for :firefox
    browser.manage().window.maximize()
    login(browser, user_name, password)
    get_page(browser)
    create_page(browser)
    post_page(browser)
    association_box(browser)
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
    association_box(browser)
    browser.quit
  end

  def association_box(browser)
    browser.get(@base_url + "/assays/new?class=experimental")
    assert browser.find_element(:xpath, "//form[@id='new_assay']/div[11]/div").text == "Data files"
    browser.find_element(:xpath, "//form[@id='new_assay']/div[11]/div").click
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until { browser.find_element(:id, "possible_data_files").displayed? }
    Selenium::WebDriver::Support::Select.new(browser.find_element(:id, "possible_data_files")).select_by(:text, "3' or Whole Gene Expression Array Template (Affymetrix)")
    verify { assert browser.find_element(:css, "ul.related_asset_list > li").text == "3' or Whole Gene Expression Array Template (Affymetrix)  [remove]" }
    browser.find_element(:link, "remove").click
    verify{  assert_equal "None", browser.find_element(:id, "data_file_to_list").text }
    browser.find_element(:id, "include_other_project_data_files").click
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until { browser.find_element(:id, "possible_data_files").displayed? }
    Selenium::WebDriver::Support::Select.new(browser.find_element(:id, "possible_data_files")).select_by(:text, "090714 chemostat overview fluxes & quinones wt")
    verify { assert_equal "090714 chemostat overview fluxes & quinones wt  [remove]", browser.find_element(:css, "ul.related_asset_list > li").text }
  end

  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end

  def post_page(browser)
    simulate_jws browser
  end

  def simulate_jws(browser)
    browser.get @base_url + "models/144?version=8"
    simulate_link = browser.find_element(:link_text, 'Simulate Model on JWS')
    simulate_link.click
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    wait.until { browser.find_element(:id => "jws_simulator_wrapper") }
  end

  def get_page(browser)
    #homepage
    browser.get @base_url
    verify {  assert_equal('The SEEK',browser.title) }

    #yellow pages
    browser.get @base_url + "programmes"
    verify {  assert_equal('The SEEK Programmes',browser.title) }
    browser.get @base_url + "programmes/2"
    verify {  assert_equal('The SEEK Programmes',browser.title) }
    browser.get @base_url + "people"
    verify {  assert_equal('The SEEK People',browser.title) }
    browser.get @base_url + "people/372"
    verify {  assert_equal('The SEEK People',browser.title) }
    browser.get @base_url + "projects"
    verify {  assert_equal('The SEEK Projects',browser.title) }
    browser.get @base_url + "projects/19"
    verify {  assert_equal('The SEEK Projects',browser.title) }
    browser.get @base_url + "institutions"
    verify {  assert_equal('The SEEK Institutions',browser.title) }
    browser.get @base_url + "institutions/7"
    verify {  assert_equal('The SEEK Institutions',browser.title) }

    #isa
    browser.get @base_url + "investigations"
    verify {  assert_equal('The SEEK Investigations',browser.title) }
    browser.get @base_url + "investigations/56"
    verify {  assert_equal('The SEEK Investigations',browser.title) }
    browser.get @base_url + "studies"
    verify {  assert_equal('The SEEK Studies',browser.title) }
    browser.get @base_url + "studies/138"
    verify {  assert_equal('The SEEK Studies',browser.title) }
    browser.get @base_url + "assays"
    verify {  assert_equal('The SEEK Assays',browser.title) }
    browser.get @base_url + "assays/296"
    verify {  assert_equal('The SEEK Assays',browser.title) }

    #assets
    browser.get @base_url + "data_files"
    verify {  assert_equal('The SEEK Data files',browser.title) }
    browser.get @base_url + "data_files/1101"
    verify {  assert_equal('The SEEK Data files',browser.title) }
    browser.get @base_url + "data_files/1101/explore?version=1"
    verify {  assert_equal('The SEEK Data files',browser.title) }
    browser.get @base_url + "models"
    verify {  assert_equal('The SEEK Models',browser.title) }
    browser.get @base_url + "models/138"
    verify {  assert_equal('The SEEK Models',browser.title) }
    browser.get @base_url + "sops"
    verify {  assert_equal('The SEEK SOPs',browser.title) }
    browser.get @base_url + "sops/203"
    verify {  assert_equal('The SEEK SOPs',browser.title) }
    browser.get @base_url + "publications"
    verify {  assert_equal('The SEEK Publications',browser.title) }
    browser.get @base_url + "publications/240"
    verify {  assert_equal('The SEEK Publications',browser.title) }

    #biosamples
    #browser.get @base_url + "biosamples"
    #verify {  assert_equal('The SEEK Biosamples',browser.title) }
    browser.get @base_url + "organisms/1933753700"
    verify {  assert_equal('The SEEK Organisms',browser.title) }
    browser.get @base_url + "strains"
    verify {  assert_equal('The SEEK Strains',browser.title) }
    browser.get @base_url + "strains/27"
    verify {  assert_equal('The SEEK Strains',browser.title) }
    #browser.get @base_url + "specimens"
    #verify {  assert_equal('The SEEK Cell cultures',browser.title) }
    #browser.get @base_url + "specimens/2"
    #verify {  assert_equal('The SEEK Cell cultures',browser.title) }
    #browser.get @base_url + "samples"
    #verify {  assert_equal('The SEEK Samples',browser.title) }
    #browser.get @base_url + "samples/2"
    #verify {  assert_equal('The SEEK Samples',browser.title) }

    #activities
    browser.get @base_url + "presentations"
    verify {  assert_equal('The SEEK Presentations',browser.title) }
    browser.get @base_url + "presentations/52"
    verify {  assert_equal('The SEEK Presentations',browser.title) }
    browser.get @base_url + "presentations/52/content_blobs/2149/view_pdf_content"
    verify {  assert_equal('The SEEK : Viewing SeekNewFeaturesPalsParis2013.odp',browser.title) }
    browser.get @base_url + "events"
    verify {  assert_equal('The SEEK Events',browser.title) }
    browser.get @base_url + "events/26"
    verify {  assert_equal('The SEEK Events',browser.title) }

    #help
    browser.get @base_url + "help/index"
    verify {  assert_equal('SEEK Development Help',browser.title) }
    #browser.get @base_url + "help/faq"
    #verify {  assert_equal('The SEEK Help',browser.title) }
    #browser.get @base_url + "help/templates"
    #verify {  assert_equal('The SEEK Help',browser.title) }
    #browser.get @base_url + "help/isa-best-practice"
    #verify {  assert_equal('The SEEK Help',browser.title) }

    #tags
    browser.get @base_url + "tags/"
    verify {  assert_equal('The SEEK',browser.title) }
    browser.get @base_url + "tags/19"
    verify {  assert_equal('The SEEK',browser.title) }

    #imprint
    browser.get @base_url + "home/imprint"
    verify {  assert_equal('The SEEK',browser.title) }
  end

  def login(browser, user_name, password)
    browser.get @base_url + "login"
    user_elelment = browser.find_element(:id, 'login')
    user_elelment.send_keys user_name
    password_element = browser.find_element(:id, 'password')
    password_element.send_keys password
    login_element = browser.find_element(:id, 'login_button')
    login_element.submit
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    wait.until { browser.find_element(:id => "user-menu") }
  end

  def create_page(browser)
    #assets
    browser.get @base_url + "data_files/new"
    verify {  assert_not_nil browser.find_element(:id, 'data_file_title') }
    browser.get @base_url + "models/new"
    verify {  assert_not_nil browser.find_element(:id, 'model_title') }
    browser.get @base_url + "sops/new"
    verify {  assert_not_nil browser.find_element(:id, 'sop_title') }
    browser.get @base_url + "publications/new"
    verify {  assert_not_nil browser.find_element(:id, 'protocol') }

    #biosamples
    browser.get @base_url + "strains/new"
    verify {  assert_not_nil browser.find_element(:id, 'strain_title') }
    #browser.get @base_url + "specimens/new"
    #assert_not_nil browser.find_element(:id, 'specimen_title')
    #browser.get @base_url + "samples/new"
    #assert_not_nil browser.find_element(:id, 'sample_title')

    #isa
    browser.get @base_url + "investigations/new"
    verify {  assert_not_nil browser.find_element(:id, 'investigation_title') }
    browser.get @base_url + "studies/new"
    verify {  assert_not_nil browser.find_element(:id, 'study_title') }
    browser.get @base_url + "assays/new?class=experimental"
    verify {  assert_not_nil browser.find_element(:id, 'assay_title') }

    #activities
    browser.get @base_url + "presentations/new"
    verify {  assert_not_nil browser.find_element(:id, 'presentation_title') }
    browser.get @base_url + "events/new"
    verify {  assert_not_nil browser.find_element(:id, 'event_title') }
  end
end
