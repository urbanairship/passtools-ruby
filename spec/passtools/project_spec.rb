require 'spec_helper'
require 'fakefs/spec_helpers'

describe "Project" do
  include FakeFS::SpecHelpers

  before(:each) do
    Passtools.configure(:url => 'http://foobar.com',
                        :api_key => 'i_am_an_api_key')

  end

  it "list projects" do
    stub = stub_get("http://foobar.com/project")
    Passtools::Project.list
    stub.should have_been_requested
  end

  it "get a project" do
    stub = stub_get("http://foobar.com/project/1")
    Passtools::Project.show(1)
    stub.should have_been_requested
  end

  it "get a project by external id" do
    stub = stub_get("http://foobar.com/project/id/external")
    Passtools::Project.show('external', true)
    stub.should have_been_requested
  end

  it "update a project" do
    stub = stub_write(:put, "http://foobar.com/project/1", "{\"name\":\"name\"}")
    Passtools::Project.update(1, {:name => 'name'})
    stub.should have_been_requested
  end

  it "update a project by external id" do
    stub = stub_write(:put, "http://foobar.com/project/id/external", "{\"name\":\"name\"}")
    Passtools::Project.update('external', {:name => 'name'}, true)
    stub.should have_been_requested
  end

  it "create a project" do
    stub = stub_write(:post, "http://foobar.com/project", "{\"name\":\"name\"}")
    Passtools::Project.create({:name => 'name'})
    stub.should have_been_requested
  end

  it "create a project with external id" do
    stub = stub_write(:post, "http://foobar.com/project/id/external", "{\"name\":\"name\"}")
    Passtools::Project.create({:name => 'name'}, 'external')
    stub.should have_been_requested
  end

  it "create a project from a layout" do
    stub = stub_write(:post, "http://foobar.com/project/1", "{\"name\":\"name\"}")
    Passtools::Project.create_from_layout(1, {:name => 'name'})
    stub.should have_been_requested
  end

  it "delete a project" do
    stub = stub_delete("http://foobar.com/project/1" )
    Passtools::Project.delete(1)
    stub.should have_been_requested
  end

  it "delete a project by external id" do
    stub = stub_delete("http://foobar.com/project/id/external" )
    Passtools::Project.delete('external', true)
    stub.should have_been_requested
  end

end