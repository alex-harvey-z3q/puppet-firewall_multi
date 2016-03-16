require 'spec_helper'

describe 'arrofint2arrofstr function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('arrofint2arrofstr')).to eq 'function_arrofint2arrofstr'
  end

  it 'should raise a ParseError if there is less than 1 arguments' do
    expect { scope.function_arrofint2arrofstr([]) }.to raise_error(Puppet::ParseError)
  end

  it 'should convert an array of integers' do
    result = scope.function_arrofint2arrofstr([[0, 8]])
    expect(result[0]).to eql '0'
    expect(result[1]).to eql '8'
  end

  it 'should convert an array of strings' do
    result = scope.function_arrofint2arrofstr([['0', '8']])
    expect(result[0]).to eql '0'
    expect(result[1]).to eql '8'
  end

  it 'should fail if something weird is passed in' do
    expect { scope.function_arrofint2arrofstr(['0', ['something', 'weird']]) }.to raise_error(Puppet::ParseError)
  end
end
