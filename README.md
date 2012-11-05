# PassTools

Simple ruby wrapper for the PassTools API. API documentation can be
found at the main [PassTools API wiki](https://github.com/tello/passtools-api/wiki/Methods)

## Installation

Via rubygems.org:

`$ gem install passtools`


Using Bundler:

Add this line to your application's Gemfile:

`gem 'passtools'`

And then execute:

`$ bundle install`

## Usage

The gem must be configured before any calls can be successfully made. At the very least, the api_key is required and needs to be set. You can configure multiple values from a hash:

`Passtools.configure(:api_key => 'i_am_an_api_key', :download_dir =
"/tmp")`

or from a yaml file:

`Passtools.configure_from_file('config.yml')`

You can also configure individual values directly via accessors:

`Passtools.api_key = "i_am_an_api_key"`

Once configured, there are 7 methods available to interact with the Passtools api. Returned JSON is parsed to provide Ruby data objects. 

`Passtools::Template.list`

Returns all templates associated with user specified by the api_key

`Passtools::Template.show(template_id)`

Returns detail information for individual template

`Passtools::Pass.list`

Returns list of all Passes associated with user

`Passtools::Pass.show(pass_id)`

Returns detail information for individual pass

`Passtools::Pass.create(template_id, data)`

Creates a new Pass based on specified template. Data is a nested hash containing data for
fields, see data returned from the Pass.show call for structure. 

`Passtools::Pass.update(pass_id, data)`

Updates pass data

`Passtools::Pass.download(pass_id)`

Downloads Pass to the directory named by the 'download_dir'
configuration value.  Passes are named 'PassToolsPass.pkpass'

## Example Code

Refer to the [PassTools API wiki](https://github.com/tello/passtools-api/wiki/Methods) for more information about the data returned. Generally you are most likely to be interested in data from the fieldsModel key of the Template detail data.   

Assuming you had a template with id 5 that returned the following from
Passtools::Template.show(5)["fieldsModel"]

```
 {"first_name"=>
     {"changeMessage"=>nil,
     "fieldType"=>"PRIMARY",
     "value"=>"John",
     "label"=>"First Name",
     "required"=>false},
  "last_name"=>
    {"changeMessage"=>nil,
     "fieldType"=>"PRIMARY",
     "value"=>"Doe",
     "label"=>"Last Name",
     "required"=>false}
  }
```

You could create new Pass with:

```
data = {"first_name" => { "value" => "Abraham" }, 
        "last_name" => { "value" => "Lincoln" } }
Passtools::Pass.create(5, data)
```

You could use the same hash with the update call to edit values in an
existing Pass based on the same template.  



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
