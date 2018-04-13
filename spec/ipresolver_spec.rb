RSpec.describe Ipresolver do
  it "has a version number" do
    expect(Ipresolver::VERSION).not_to be nil
  end

  let(:app) { ->(env) { env } }
  let(:ipresolver) { described_class.new(app) }
  let(:ad_request_ip) { ActionDispatch::Request.new(ipresolver.call(env)).ip }
  let(:rack_request_ip) { Rack::Request.new(ipresolver.call(env)).ip }

  describe "#call" do
    context "With no X-Forwarded-For" do
      let(:env) { {'REMOTE_ADDR' => '1.1.1.1'} }

      it "Provides REMOTE_ADDR" do
        expect(ad_request_ip).to eq('1.1.1.1')
        expect(rack_request_ip).to eq('1.1.1.1')
      end
    end

    context "With untrusted X-Forwarded-For and untrusted REMOTE_ADDR" do
      let(:env) { {'REMOTE_ADDR' => '1.1.1.1', 'HTTP_X_FORWARDED_FOR' => '2.2.2.2'} }

      it "Provides REMOTE_ADDR" do
        expect(ad_request_ip).to eq('1.1.1.1')
        expect(rack_request_ip).to eq('1.1.1.1')
      end
    end

    context "With untrusted X-Forwarded-For and trusted REMOTE_ADDR" do
      let(:env) { {'REMOTE_ADDR' => '127.0.0.1', 'HTTP_X_FORWARDED_FOR' => '2.2.2.2'} }

      it "Provides last X-Forwarded-For" do
        expect(ad_request_ip).to eq('2.2.2.2')
        expect(rack_request_ip).to eq('2.2.2.2')
      end
    end

    context "With trusted X-Forwarded-For and trusted REMOTE_ADDR" do
      let(:env) { {'REMOTE_ADDR' => '127.0.0.1', 'HTTP_X_FORWARDED_FOR' => '10.0.0.1'} }

      it "Provides last X-Forwarded-For" do
        expect(ad_request_ip).to eq('10.0.0.1')
        expect(rack_request_ip).to eq('10.0.0.1')
      end
    end
  end
end
