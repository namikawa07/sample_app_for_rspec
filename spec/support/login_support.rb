module LoginMacros
  def login_as(user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "Rspec-tester-password"
    click_button "Login"
  end
end

RSpec.configure do |config|
  config.include LoginMacros
end