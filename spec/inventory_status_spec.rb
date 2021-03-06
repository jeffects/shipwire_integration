require 'spec_helper'

describe InventoryStatus do
  let(:config) do
    {
      'shipwire_username' => 'chris@spreecommerce.com',
      'shipwire_password' => 'GBb4gv6wCjVeHV',
      'shipment_tracking_bookmark' => 1
    }
  end

  subject { described_class.new({}, config) }

  it 'posts to the InventoryServices api' do
    VCR.use_cassette('ship_wire_inventory_status') do
      expect {
        code, response = subject.consume

        code.should == 200
        response['shipwire_response'].should have_key('Product')
      }.to_not raise_error
    end
  end

  it 'builds xml body' do
    xml = subject.send :xml_body
    xml.should match '<Username>chris@spreecommerce.com</Username>'
    xml.should match '<Password>GBb4gv6wCjVeHV</Password>'
  end
end
