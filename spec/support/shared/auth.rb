RSpec.shared_examples "auth" do
  before do
    payload = { sub: :caller }
    auth_token = JWT.encode(payload, nil, "none")
    request.headers["Authorization"] = "Bearer #{auth_token}"
  end
end