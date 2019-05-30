# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  action     :text             not null
#  resource   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Permission < ApplicationRecord
  validates :action, presence: true, allow_blank: false
end
