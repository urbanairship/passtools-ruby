require 'spec_helper'

describe 'Tag' do  
  before(:all) do
    Passtools.configure(:url => 'http://foobar.com',
                        :api_key => 'i_am_an_api_key')

  end

  it "calls Passtools API for list of tags" do
    stub = stub_get("http://foobar.com/tag")

    Passtools::Tag.list
    stub.should have_been_requested
  end

  it "calls Passtools API for list of passes associated with a single tag" do
    stub = stub_get("http://foobar.com/tag/foo/passes")

    Passtools::Tag.list_passes('foo')
    stub.should have_been_requested
  end

  it "calls Passtools API to delete a location a tag" do
    stub = stub_delete("http://foobar.com/tag/foo" )

    Passtools::Tag.delete('foo')
    stub.should have_been_requested
  end

  it "calls Passtools API to remove a single pass from a tag" do
    stub = stub_delete("http://foobar.com/tag/foo/pass/1" )

    Passtools::Tag.remove_from_pass('foo', 1)
    stub.should have_been_requested
  end

  it "calls Passtools API to remove a single pass using external id from a tag" do
    stub = stub_delete("http://foobar.com/tag/foo/pass/id/bar" )

    Passtools::Tag.remove_from_pass('foo', 'bar', true)
    stub.should have_been_requested
  end

  it "calls Passtools API to remove all passes from a tag" do
    stub = stub_delete("http://foobar.com/tag/foo/passes" )

    Passtools::Tag.remove_from_all('foo')
    stub.should have_been_requested
  end







end


