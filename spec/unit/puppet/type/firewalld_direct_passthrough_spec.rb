require 'spec_helper'

describe Puppet::Type.type(:firewalld_direct_passthrough) do
  before do
    Puppet::Provider::Firewalld.any_instance.stubs(:state).returns(:true) # rubocop:disable RSpec/AnyInstance
  end

  context 'with no params' do
    describe 'when validating attributes' do
      [:inet_protocol, :args].each do |param|
        it "should have a #{param} parameter" do
          expect(described_class.attrtype(param)).to eq(:param)
        end
      end
    end

    describe 'namevar validation' do
      it 'has :args as its namevar' do
        expect(described_class.key_attributes).to eq([:args])
      end

      it 'defaults inet_protocol to ipv4' do
        resource = described_class.new(title: '-A OUTPUT -j OUTPUT_filter')
        expect(resource[:inet_protocol]).to eq('ipv4')
      end

      it 'raises an error if given malformed inet protocol' do
        expect { described_class.new(title: '-A OUTPUT -j OUTPUT_filter', inet_protocol: 'bad') }.to raise_error(Puppet::Error)
      end
    end
  end

  describe 'provider' do
    let(:resource) do
      described_class.new(
        name: 'Forward OUTPUT',
        ensure: 'present',
        inet_protocol: 'ipv4',
        args: '-A OUTPUT -j OUTPUT_filter'
      )
    end

    let(:provider) { resource.provider }

    it 'creates' do
      provider.expects(:execute_firewall_cmd).with(['--direct', '--add-passthrough', ['ipv4', '-A', 'OUTPUT', '-j', 'OUTPUT_filter']], nil)
      provider.create
    end
    it 'destroys' do
      provider.expects(:execute_firewall_cmd).with(['--direct', '--remove-passthrough', ['ipv4', '-A', 'OUTPUT', '-j', 'OUTPUT_filter']], nil)
      provider.destroy
    end
  end
end
