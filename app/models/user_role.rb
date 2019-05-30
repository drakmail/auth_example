# frozen_string_literal: true

# == Schema Information
#
# Table name: user_roles
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  role_id    :bigint           not null
#  kind       :integer          default("default"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  enum kind: {
    default: 0,
    for_user: 1
  }
end
