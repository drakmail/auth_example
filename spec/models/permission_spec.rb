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

require 'rails_helper'

RSpec.describe Permission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
