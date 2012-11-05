require 'spec_helper'

describe 'Template' do  
  before(:all) do
    Passtools.configure(:url => 'http://foobar.com',
                        :api_key => 'i_am_an_api_key')

  end

  it "calls Passtools API for list of template headers" do
    stub = stub_get("http://foobar.com/template/headers")

    Passtools::Template.list
    stub.should have_been_requested
  end

  it "calls Passtools API for individual template detail" do
    stub = stub_get("http://foobar.com/template/55")

    Passtools::Template.show(55)
    stub.should have_been_requested
  end
  
end
