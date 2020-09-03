# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'validations' do
    it 'requires title' do
      achievement = Achievement.new(title: '')
      expect(achievement.valid?).to be_falsy
      expect(achievement.errors[:title]).to_not be_empty
      expect(achievement.errors[:title]).to include("can't be blank")
    end

    it 'requires title to be unique for one user' do
      user = FactoryBot.create(:user)
      first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user)
      new_achievement = Achievement.new(title: 'First Achievement', user: user)
      expect(new_achievement.valid?).to be_falsy
    end

    it 'allows different users to have achievements with identical titles' do
      user1 = FactoryBot.create(:user)
      first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user1)

      user2 = FactoryBot.create(:user)
      new_achievement = Achievement.new(title: 'First Achievement', user: user2)

      expect(new_achievement.valid?).to be_truthy
    end
  end

  it 'belongs to user' do
    achievement = Achievement.new(title: 'some title', user: nil)
    expect(achievement.valid?).to be_falsy
  end

  it 'has belongs_to user association' do
    # 1 approach
    user = FactoryBot.create(:user)
    achievement = FactoryBot.create(:public_achievement, user: user)
    expect(achievement.user).to eq(user)

    # 2 approach
    u = Achievement.reflect_on_association(:user)
    expect(u.macro).to eq(:belongs_to)
  end

  # ==

  let(:user) { FactoryBot.create(:user) }
  subject { FactoryBot.create(:public_achievement, user: user) }

  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title).scoped_to(:user_id).with_message("you can't have two achievements with the same title") }
  it { should validate_presence_of(:user) }
  it { should belong_to(:user) }

  it 'converts markdown to html' do
    achievement = Achievement.new(description: 'Awesome **thing** I *actually* did')
    expect(achievement.description_html).to include('<strong>thing</strong>')
    expect(achievement.description_html).to include('<em>actually</em>')
  end

  it 'has silly title' do
    achievement = Achievement.new(title: 'New Achievement', user: FactoryBot.create(:user, email: 'test@test.com'))
    expect(achievement.silly_title).to eq('New Achievement by test@test.com')
  end

  it 'only fetches achievements which title starts from provided letter' do
    achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: user)
    achievement2 = FactoryBot.create(:public_achievement, title: 'Passed an exam', user: user)
    expect(Achievement.by_letter('R')).to eq([achievement1])
  end

  it 'sorts achievements by user emails' do
    albert = FactoryBot.create(:user, email: 'albert@email.com')
    rob = FactoryBot.create(:user, email: 'rob@email.com')
    achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: rob)
    achievement2 = FactoryBot.create(:public_achievement, title: 'Rocked it', user: albert)
    expect(Achievement.by_letter('R')).to eq([achievement2, achievement1])
  end
end
