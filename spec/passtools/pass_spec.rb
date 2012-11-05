require 'spec_helper'
require 'fakefs/spec_helpers'

describe 'Pass' do

  include FakeFS::SpecHelpers
  before(:each) do
    Passtools.configure(:url => 'http://foobar.com',
                        :api_key => 'i_am_an_api_key',
                        :download_dir => '.')
  end

  it "calls Passtools API for list of Passes" do
    stub = stub_get("http://foobar.com/pass")

    Passtools::Pass.list
    stub.should have_been_requested
  end

  it "calls Passtools API for individual Pass detail" do
    stub = stub_get("http://foobar.com/pass/55")

    Passtools::Pass.show(55)
    stub.should have_been_requested
  end

  it "calls Passtools API to download Pass" do
    stub = stub_get("http://foobar.com/pass/55/download", 'contents of pass')

    Passtools::Pass.download(55)
    File.open("PassToolsPass.pkpass", 'r').read.should == "contents of pass"
  end

  it "calls Passtools API to create new Pass" do
    stub = stub_write(:post, "http://foobar.com/pass/22", "{\"foo\":\"bar\"}" )

    Passtools::Pass.create(22, {:foo => :bar })
    stub.should have_been_requested
  end

  it "calls Passtools API to update new Pass" do
    stub = stub_write(:put, "http://foobar.com/pass/55", "{\"foo\":\"bar\"}" )

    Passtools::Pass.update(55, {:foo => :bar })
    stub.should have_been_requested
  end

  it "raises descriptive error if directory does not exist when downloading" do
    Passtools.configure(:download_dir => "/asdfasdfasfd")
    expect {Passtools::Pass.download(55)}.to raise_error(RuntimeError, /Download directory is not defined or does not exist/)
  end

  it "raises descriptive error if directory is not defined when downloading" do
    Passtools.configure(:download_dir => nil)
    expect {Passtools::Pass.download(55)}.to raise_error(RuntimeError, /Download directory is not defined or does not exist/)
  end

  it "raises error if url is empty" do
    Passtools.configure(:url => '')
    expect {Passtools::Pass.list}.to raise_error(RuntimeError, /You must configure API url before calling/)
  end


  it "raises error if api_key is not set" do
    Passtools.configure(:api_key => nil)
    expect {Passtools::Pass.list}.to raise_error(RuntimeError, /You must configure api_key before calling/)
  end

end
