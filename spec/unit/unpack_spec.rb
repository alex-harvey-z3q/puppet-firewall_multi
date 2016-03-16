require 'spec_helper'

describe 'unpack function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('unpack')).to eq 'function_unpack'
  end

  it 'should raise a ParseError if there is less than 1 arguments' do
    expect { scope.function_unpack([]) }.to raise_error(Puppet::ParseError)
  end

  it 'should convert description__x.x.x.x/x__y.y.y.y/y__nn' do
    result = scope.function_unpack(['description__x.x.x.x/x__y.y.y.y/y__nn'])
    expect(result['description']).to eq 'description from x.x.x.x/x to y.y.y.y/y icmp type nn'
    expect(result['from']).to eq 'x.x.x.x/x'
    expect(result['to']).to eq 'y.y.y.y/y'
    expect(result['icmp']).to eq 'nn'
  end

  it 'should convert description__undef__undef__undef' do
    result = scope.function_unpack(['description__undef__undef__undef'])
    expect(result['description']).to eq 'description'
    expect(result['from']).to be_nil
    expect(result['to']).to be_nil
    expect(result['icmp']).to be_nil
  end

end
