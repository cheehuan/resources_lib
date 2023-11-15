require 'spec_helper'

describe 'resources_default' do
  it { is_expected.not_to eq(nil) }

  it { is_expected.to run.with_params }

  it { is_expected.to run.with_params(false) }

  it { is_expected.to run.with_params(true) }

  it { is_expected.to run.with_params('bad_input').and_raise_error(ArgumentError) }

  context "should give every resource a default of 'noop => true' when no argument is passed" do
    let(:pre_condition) { 'resources_default({}); file {"/tmp/foo":}' }

    it {
      expect(catalogue).to contain_file('/tmp/foo')
    }
  end

  context 'should work when resource collectors perform overrides' do
    # Context: When using noop() and a resource collector to perform overrides we would fail when all these conditions were met:
    # 1) A resource collector was defined in a child scope from the noop() call
    # 2) The resource collector successfully collected its resource
    # 3) The resource collector was overriding some parameter
    # 4) This parameter was not the noop parameter
    # 5) The noop parameter was not set as a default (e.g. File { noop => true } )
    #
    # This is because the resource collector internally creates a resource (which gets noop => true) and
    # would merge it into the existing resource (which also had noop => true). The code would try to override
    # the noop parameter but would fail.
    let(:pre_condition) do
      <<-EOS
  resources_default({})
  class myclass {
    file { "/tmp/foo": }
    File <| title == "/tmp/foo" |> {
      ensure => present,
    }
  }
  include myclass
EOS
    end

    it {
      expect(catalogue).to contain_file('/tmp/foo').with_noop(true)
    }
  end
end
