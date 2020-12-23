require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) {FactoryBot.create(:user)}
  let(:task) {FactoryBot.create(:task)}

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit root_path
          click_link "SignUp"
          fill_in "Email", with: "email@example.com"
          fill_in "Password", with: "password"
          fill_in "Password confirmation", with: "password"
          click_button "SignUp"
          expect(page).to have_content("User was successfully created.")
          expect(current_path).to eq login_path
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit root_path
          click_link "SignUp"
          fill_in "Password", with: "password"
          fill_in "Password confirmation", with: "password"
          click_button "SignUp"
          expect(page).to have_content("can't be blank")
          expect(current_path).to eq users_path
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          user = FactoryBot.create(:user, email: "rspectest@example.com")
          visit root_path
          click_link "SignUp"
          fill_in "Email", with: "rspectest@example.com"
          fill_in "Password", with: "password"
          fill_in "Password confirmation", with: "password"
          click_button "SignUp"
          expect(page).to have_content("has already been taken")
          expect(current_path).to eq users_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(page).to have_content("Login required")
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          login_as(user)
          visit edit_user_path(user)
          fill_in "Email", with: "rspectester@example.com"
          fill_in "Password", with: "password-change"
          fill_in "Password confirmation", with: "password-change"
          click_button "Update"
          expect(page).to have_content("User was successfully updated.")
          expect(current_path).to eq user_path(user)
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          login_as(user)
          visit edit_user_path(user)
          fill_in "Email", with: nil
          fill_in "Password", with: "password-change"
          fill_in "Password confirmation", with: "password-change"
          click_button "Update"
          expect(page).to have_content("can't be blank")
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          other_user = FactoryBot.create(:user, email: "emailtester@example.com")
          login_as(user)
          visit edit_user_path(user)
          fill_in "Email", with: "emailtester@example.com"
          fill_in "Password", with: "password-change"
          fill_in "Password confirmation", with: "password-change"
          click_button "Update"
          expect(page).to have_content("has already been taken")
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          other_user = FactoryBot.create(:user)
          login_as(user)
          visit edit_user_path(other_user)
          expect(page).to have_content("Forbidden access.")
          expect(current_path).to eq user_path(user)
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          login_as(user)
          create(:task, title: 'test_title', status: 'doing', user: user)
          visit user_path(user)
          expect(page).to have_content('You have 1 task.')
          expect(page).to have_content('test_title')
          expect(page).to have_content('doing')
          expect(page).to have_link('Show')
          expect(page).to have_link('Edit')
          expect(page).to have_link('Destroy')
        end
      end
    end
  end
end
