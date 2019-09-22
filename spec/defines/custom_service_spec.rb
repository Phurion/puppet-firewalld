require 'spec_helper'

describe 'firewalld::custom_service' do
  let(:title) { 'My Service' }
  let(:xml) do
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'services', 'custom_service.xml'))
  end

  let(:xml_port_range) do
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'services', 'custom_service_port_range.xml'))
  end

  context 'when defining with specific ports' do
    let(:params) do
      {
        short: 'myservice',
        description: 'My multi port service',
        port: [
          {
            'port'     => '8000',
            'protocol' => 'tcp'
          },
          {
            'port'     => '8000',
            'protocol' => 'udp'
          },
          {
            'port'     => '8001',
            'protocol' => 'tcp'
          },
          {
            'port'     => '8001',
            'protocol' => 'udp'
          },
          {
            'port'     => '8002',
            'protocol' => 'tcp'
          },
          {
            'port'     => '8002',
            'protocol' => 'udp'
          },
          {
            'port'     => '',
            'protocol' => 'vrrp'
          }
        ],
        module: ['nf_conntrack_netbios_ns'],
        destination: {
          'ipv4' => '127.0.0.1',
          'ipv6' => '::1'
        }
      }
    end

    it do
      is_expected.to contain_file('/etc/firewalld/services/myservice.xml').with(
        content: xml
      )
    end
  end
  context 'when defining with specific filename' do
    let(:params) do
      {
        short: 'myservice',
        filename: 'myservice_file',
        description: 'My multi port service',
        port: [
          {
            'port'     => '8000',
            'protocol' => 'tcp'
          },
          {
            'port'     => '8000',
            'protocol' => 'udp'
          },
          {
            'port'     => '8001',
            'protocol' => 'tcp'
          },
          {
            'port'     => '8001',
            'protocol' => 'udp'
          },
          {
            'port'     => '8002',
            'protocol' => 'tcp'
          },
          {
            'port'     => '8002',
            'protocol' => 'udp'
          },
          {
            'protocol' => 'vrrp'
          }
        ],
        module: ['nf_conntrack_netbios_ns'],
        destination: {
          'ipv4' => '127.0.0.1',
          'ipv6' => '::1'
        }
      }
    end

    it do
      is_expected.to contain_file('/etc/firewalld/services/myservice_file.xml').with(
        content: xml
      )
    end
  end
  context 'when defining with integer ports' do
    let(:params) do
      {
        short: 'myservice',
        filename: 'myservice_file',
        description: 'My multi port service',
        port: [
          {
            'port'     => 8000,
            'protocol' => 'tcp'
          },
          {
            'port'     => 8000,
            'protocol' => 'udp'
          },
          {
            'port'     => 8001,
            'protocol' => 'tcp'
          },
          {
            'port'     => 8001,
            'protocol' => 'udp'
          },
          {
            'port'     => 8002,
            'protocol' => 'tcp'
          },
          {
            'port'     => 8002,
            'protocol' => 'udp'
          },
          {
            'port'     => '',
            'protocol' => 'vrrp'
          }

        ],
        module: ['nf_conntrack_netbios_ns'],
        destination: {
          'ipv4' => '127.0.0.1',
          'ipv6' => '::1'
        }
      }
    end

    it do
      is_expected.to contain_file('/etc/firewalld/services/myservice_file.xml').with(
        content: xml
      )
    end
  end
  context 'when defining with a port range' do
    let(:params) do
      {
        short: 'myservice',
        description: 'My multi port service',
        port: [
          {
            'port'     => '8000:8002',
            'protocol' => 'tcp'
          },
          {
            'port'     => '8000:8002',
            'protocol' => 'udp'
          }
        ],
        module: ['nf_conntrack_netbios_ns'],
        destination: {
          'ipv4' => '127.0.0.1',
          'ipv6' => '::1'
        }
      }
    end

    it do
      is_expected.to contain_file('/etc/firewalld/services/myservice.xml').with(
        content: xml_port_range
      )
    end
  end
end


