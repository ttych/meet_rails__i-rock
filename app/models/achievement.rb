# frozen_string_literal: true

class Achievement < ApplicationRecord
  validates :title, presence: true

  enum privacy: %i[public_access private_access friends_access]
end
