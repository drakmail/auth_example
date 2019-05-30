# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :integer          default("default"), not null
#

class Role < ApplicationRecord
  validates :title, presence: true, allow_blank: false, if: :default?

  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  enum kind: {
    default: 0,
    for_user: 1
  }
end
