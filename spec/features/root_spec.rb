require "spec_helper"

feature "homepage" do

  scenario "should have a registration button" do
    visit "/"

    expect(page).to have_link("Register", options = {href: "/register"})

  end

feature "register" do
  scenario "should have registration form, and then be able to login" do
    visit "/register"

    fill_in "username", with: "S"
    fill_in "password", with: "D"
    click_button "Register"

    expect(page).to have_content("The Login Page")
  end
  end


feature "error page" do
  scenario "should have button returning to homepage" do
    visit "/error"

  expect(page). to have_link("Try again", options = {href: "/"})
  end


end





end
















