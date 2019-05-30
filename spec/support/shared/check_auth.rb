RSpec.shared_examples "check_auth" do |method, endpoint|
  let(:method) { method }
  let(:endpoint) { endpoint }

  it "require auth" do
    send method, endpoint, format: :json

    expect(response.code).to eq "403"
    expect(json_body["success"]).to eq false
    expect(json_body["errors"]).to eq ["AUTH_REQUIRED"]
  end
end