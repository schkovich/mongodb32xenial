require 'spec_helper'
describe 'mongodb32xenial' do
  context 'with default values for all parameters' do
    it { should contain_class('mongodb32xenial') }
  end
end
