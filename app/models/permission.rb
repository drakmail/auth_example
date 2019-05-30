# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  action     :text
#  resource   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Permission < ApplicationRecord
end
