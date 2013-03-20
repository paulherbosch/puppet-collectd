#!/usr/bin/env rspec

require 'spec_helper'

describe 'collectd' do
  it { should contain_class 'collectd' }
end
