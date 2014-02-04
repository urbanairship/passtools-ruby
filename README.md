# PassTools

* Simple ruby wrapper for the PassTools API. 
* API documentation can be found at the main [PassTools API wiki](https://github.com/tello/passtools-api/wiki/Methods)
* Indexed documentation for the Ruby SDK is available at [http://tello.github.com/passtools-ruby/](http://tello.github.com/passtools-ruby/).


## Installation

### Via rubygems.org:

`$ gem install passtools`

#### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- or - 

### Using Bundler:

Add this line to your application's Gemfile:

`gem 'passtools'`

And then execute:

`$ bundle install`

## Usage

The gem must be configured before any calls can be successfully made. At the very least, the api_key is required and needs to be set. You can configure multiple values from a hash:

`Passtools.configure(:api_key => 'i_am_an_api_key', :download_dir => "/tmp")`

or from a yaml file:

`Passtools.configure_from_file('config.yml')`

You can also configure individual values directly via accessors:

`Passtools.api_key = "i_am_an_api_key"`

Once configured, there are 9 methods available to interact with the Passtools api. Returned JSON is parsed to provide Ruby data objects. 

`Passtools::Template.list`

Returns all templates associated with user specified by the api_key

`Passtools::Template.show(template_id)`

Returns detail information for individual template

`Passtools::Template.delete(template_id)`

Deletes a template from the user's account

### Using Passes:
As indicated most Pass calls also take an optional external_id_flag
boolean arguement. If set to true, the pass_id is considered to be an
external_id when retrieving or setting information. The create method is
slightly different as this is where the external_id is set. 

`Passtools::Pass.list`

Returns list of all Passes associated with user

`Passtools::Pass.show(pass_id, external_id_flag)`

Returns detail information for individual pass

`Passtools::Pass.create(template_id, data, external_id)`

Creates a new Pass based on specified template. Data is a nested hash containing data for
fields, see data returned from the Pass.show call for structure. If the
external_id parameter is present, this will be added to the Pass.


`Passtools::Pass.add_locations(pass_id, data, external_id_flag)`

Add up to 10 'Relevant Locations' to pass. Data is a list containing data for
locations, for example:

`data = [{"latitude"=>37.4471107, "longitude"=>-122.16206219999998,
         	"streetAddress1"=>"408 Florence St", "streetAddress2"=>"",
            "city"=>"Palo Alto", "region"=>"CA", "regionCode"=>"94301",
            "country"=>"US", "relevantText"=>"Palo Alto Office!"}]` 


`Passtools::Pass.delete_location(pass_id, location_id, external_id_flag)`

Delete one 'Relevant Location' from pass. Location to be deleted should be specified by ID, available in data returned from the Psss.show call. 

`Passtools::Pass.update(pass_id, data)`

Updates pass data

`Passtools::Pass.download(pass_id, external_id_flag)`

Downloads Pass to the directory named by the 'download_dir'
configuration value.  Passes are named 'PassToolsPass.pkpass'

`Passtools::Pass.delete(pass_id, external_id_flag)`

Delete pass from user's account

`Passtools::Pass.push(pass_id, external_id_flag)`

Push pass changes to all devices that have the pass installed

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

## Using utility objects

There are some additional methods wrapping the data returned and
creating an instantiated object that provides some methods for
convenience

There are three constructors:

`Passtools::Template.build_from_current(template_id)`

returns a Template instance that has read only accessors for the raw
data, id, field names, and a field data hash that can be used for Pass 
creation.

`Passtools::Pass.build_from_current(pass_id)`

returns a Pass instance that has read only accessors for id and
template id. It also has read/write accessors for the raw data
returned and each of the fields.  Changes to either the raw data or the
fields can be persisted with the #update method. 

`Passtools::Pass.build_from_template(@template_instance)`

returns a templated Pass instance that has the same accessors as above.
This instance can be persisted with the #create method. Once it
persisted, further changes must be persisted with the #update method

Each Pass or Template instance has access to the API methods that make sense
for an single object(eg. create, update, push, delete). 

## Usage 

Given the same example as above you could:

```
template = Passtools::Template.build_from_current(5)
pass = Passtools::Pass.build_from_template(template)
pass.first_name['value'] = 'Abraham'
pass.last_name['value] = 'Lincoln'
pass.create
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
