require 'rcal'
require 'rcal/auth'

describe RCal::RCal do
  describe '#initialize' do
    let(:rcal) { RCal::RCal.new }
    let(:auth) { instance_double('AuthModule') }

    it 'should be an instance of Rcal' do
      expect(rcal).instance_of? RCal::RCal
    end

    it 'should setup credentials' do
      # expect(auth).to receive(:credentials)
      # RCal::RCal.new
    end

    it 'should setup color modes from config file' do
      puts "It is doing something with #{rcal}."
    end
  end
end
