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

  context "The Template instance" do
    context 'when built from succesful api call' do
      before(:all) do
        @data = {"templateHeader" => {"id" => 55},
                "fieldsModel" => {"first_name" => {"value" => "first", "required" => false},
                                  "last_name" => {"value" => "last", "required" => true}}
               }
        stub = stub_get("http://foobar.com/template/55",@data)
        @template = Passtools::Template.build_from_current(55)
      end

      it "should return id" do
        @template.id.should == 55
      end

      it "should be valid" do
        @template.valid?.should be_true
      end

      it "should return the correct field names" do
        @template.field_names.should == ['first_name', 'last_name']
      end

      it "should return the correct complete field data" do 
        @template.fields.should == @data['fieldsModel']
      end

    end
    context "when built from failed api call" do
      before(:all) do
      end

      it "should capture error information" do
        stub_error("http://foobar.com/template/55", 400)
        @template = Passtools::Template.build_from_current(55)
        @template.raw_data['message'].should == "400 Bad Request"
      end

      it "should not be valid" do
        stub_error("http://foobar.com/template/55", 400)
        @template = Passtools::Template.build_from_current(55)
        @template.valid?.should be_false
      end

    end
  end
  
end
