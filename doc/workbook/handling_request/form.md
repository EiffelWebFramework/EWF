Nav: [Workbook](../workbook.md) | [Basic Concepts] (/doc/workbook/basics/basics.md) | [Handling Requests: Header Fields](/doc/workbook/handling_request/headers.md) 


#Handling Requests: Form/Query Data


##### Table of Contents  
- [Reading Form Data](#read)
  - [Query Parameters](#query)
  - [Form Parameters](#form)
  - [Uniform Read](#uniform)
- [Reading Parameters and Values](#reading_pv) 
  - [How to read all parameters names](#all_names)
  - [How to read single values](#single_values)
  - [How to read multiple values](#multiple_values)
  - [How to read table values](#table_values)
- [Reading raw data](#raw_data)
- [Upload Files](#upload)
- [Examples](#examples)
 

An HTML Form can handle GET and POST requests.
When we use a form with method GET, the data is attached at the end of the url for example:

>http://wwww.example.com?key1=value1&...keyn=valuen

If we use the method POST, the data is sent to the server in a different line.

Extracting form data from the server side is one of the most tedious parts. If you do it by hand, you will need 
to parse the input, you'll have to URL-decode the value.

Here we will show you how to read input submitted by a user using a Form (GET and POST).
 * How to handle missing values:
   * client side validattion, server side validations, set default if it's a valid option.
 * How to populate Eiffel objects from the request data.          

<a name="read"/>
## Reading Form Data
EWF [WSF_REQUEST]() class, provides features to handling this form parsing automatically.

<a name="query"/>
### Query Parameters

	WSF_REQUEST.query_parameters: ITERABLE [WSF_VALUE]
			-- All query parameters
	
	WSF_REQUEST.query_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Query parameter for name `a_name'.
<a name="form"/>
### Form Parameters

	WSF_REQUEST.form_parameters: ITERABLE [WSF_VALUE]
      			-- All form parameters sent by a POST
      
	WSF_REQUEST.form_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Field for name `a_name'.

The values supplied to form_parameter and query_parameter are case sensitive.

<a name="uniform"/>
### Read Data
The previous features, let you read the data one way for GET request and a different way for POST request. WSF_REQUEST provide a feature to read all the data in a uniform way.

	WSF_REQUEST.item (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Variable named `a_name' from any of the variables container
			-- and following a specific order: form_, query_ and path_ parameters

So, you use **WSF_REQUEST.item** feature exactly the same way for GET and POST request.

>Note: if a query parameter has the same name as a form paramenter req.item will retrieve the form paramenter. Remember the precedence: form > query > path 


<a name="reading_pv">
## Reading Parameters and Values

Suppose we have the following HTML5 form using Method POST. This HTML5 form has client side form validation using the new HTML5 attribute, you can do the same using Javascript. So in this case if the user does not fill the fields as expected the form will not be submitted to the server.

>Note: You want to validate on the server side because you can protect against the malicious user, who can easily bypass your JavaScript and submit dangerous input to the server.

```
<h1> EWF Handling Client Request: Form example </h1>  
<form action="/" method="POST">
 <fieldset> 
    <legend>Personal details</legend> 
    <div> 
        <label>First Name
	    <input id="given-name" name="given-name" type="text" placeholder="First name only" required autofocus> 
	</label>
   </div>
   <div> 
        <label>Last Name
	    <input id="family-name" name="family-name" type="text" placeholder="Last name only" required autofocus> 
	</label>
    </div>
    <div>
	 <label>Email 
	    <input id="email" name="email" type="email" placeholder="example@domain.com" required>
	</label> 
    </div> 
    <div>  
       <label>Languages 
	  <input type="checkbox" name="languages" value="Spanish"> Spanish
	  <input type="checkbox" name="languages" value="English"> English 
	</label> 
     </div> 
  </fieldset>
  <fieldset> 
  	<div> 
	    <button type=submit>Submit Form</button> 
	 </div> 
  </fieldset> 
</form>
```
<a name="all_names">
### How to read all parameter names
To read all the parameters names we simple call WSF_REQUEST.form_parameters. 

```
 req: WSF_REQUEST
 across req.form_parameters as ic loop show_parameter_name (ic.item.key) end
```
<a name="single_values">
### How to read single values
To read a particular parameter, a single value, for example `given-name', we simple call WSF_REQUEST.form_parameter (a_name) and we check if it's attached to WSF_STRING (represents a String parameter)
```
  req: WSF_REQUEST 
  if attached {WSF_STRING} req.form_paramenter ('given-name') as l_given_name then
  	-- Work with the given parameter, for example populate an USER object
  	-- the argument is case sensitive
  else
        -- Value missing, check the name against the HTML form 
  end
```
<a name="multiple_values">
### How to read multiple values

To read multiple values, for example in the case of `languages', we simple call WSF_REQUEST.form_parameter (a_name) and we check if it's attached to WSF_MULTIPLE_STRING (represents a String parameter)

```
  req: WSF_REQUEST 
  idioms: LIST[STRING]
  	-- the argument is case sensitive
  if attached {WSF_MULTIPLE_STRING} req.form_paramenter ('languages') as l_languages then
  	-- Work with the given parameter, for example populate an USER object
  	-- Get all the associated values
  	create {ARRAYED_LIST[STRING]} idioms.make (2)
	across l_languages as ic loop idioms.force (ic.item.value) end
  elseif attached {WSF_STRING} req.form_paramenter ('languages') as l_language then
        -- Value missing, check the name against the HTML form 
        create {ARRAYED_LIST[STRING]} idioms.make (1)
	idioms.force (l_language.value)
  else
  	-- Value missing 
  end
```
In this case we are handling strings values, but in some cases you will need to do a conversion, betweend the strings that came from the request to map them to your domain model. 

<a name="table_values">
### How to read table values
This is particularly useful when you have a request with the following format

``` <a href="/link?tab[a]=1&tab[b]=2&tab[c]=foo"> ```

To read table values, for example in the case of `tab', we simple call WSF_REQUEST.form_parameter (a_name) and we check if it's attached to WSF_TABLE.

```
if attached {WSF_TABLE} req.query_parameter ("tab") as l_tab then
	l_parameter_names.append ("<br>")
	l_parameter_names.append (l_tab.name)
	from
		l_tab.values.start
	until
		l_tab.values.after
	loop
		l_parameter_names.append ("<br>")
		l_parameter_names.append (l_tab.values.key_for_iteration)
		if attached {WSF_STRING} l_tab.value (l_tab.values.key_for_iteration) as l_value then
			l_parameter_names.append ("=")
			l_parameter_names.append (l_value.value)
		end
		l_tab.values.forth
	end
end	
```

<a name="raw_data">
## Reading Raw Data
You can also access the data in raw format, it means you will need to parse and url-decode it, and also you will not be able to use the previous features, by default, to enable that you need to call `req.set_raw_input_data_recorded (True)'. This feature (reading raw data) is useful if you are reading POST data with JSON or XML formats, but it's not convinient for HTML forms.

To read raw data you need to do this

```
   l_raw_data:STRING
   
   req.set_raw_input_data_recorded (True) --
   create l_raw_data.make_empty
   req.read_input_data_into (l_raw_data)
```

> given-name=testr&family-name=test&dob=1976-08-26&email=test%40gmail.com&url=http%3A%2F%2Fwww.eiffelroom.com&phone=455555555555&languages=Spanish&languages=English			

<a name=upload></a>
## Upload Files
How can we read data when the date come from an uploaded file/s?. 
HTML supports a form element ```<input type="File" ... > ``` to upload a single file and ```<input type="File" ... multiplr> ``` to upload multiple files.

So supose we have the following form

```
<!DOCTYPE html>
<html>
  <head>
    <title>EWF Handling Client Request: File Upload Example</title>
  </head>
  <body>
    <h1> EWF Handling Client Request: File Upload Example</h1>  
    <form action="/upload"  enctype="multipart/form-data" method="POST">
       <fieldset> 
          <legend>Upload file/s</legend> 
          <div> 
              <label>File
              <input name="file-name[]" type="file" multiple> 
          </label>
        <fieldset> 
            <div> 
              <button type=submit>Send</button> 
            </div> 
        </fieldset> 
    </form> 
  </body> 
</html>
```

The class WSF_REQUEST has defines mechanism to work with uploaded files. We can call the query

```
WSF_REQUEST.has_uploaded_file: BOOLEAN
      -- Has any uploaded file?
```

to check if the request form parameters has any uploaded file, and we can call the feature

```
WSF_REQUEST.uploaded_files: ITERABLE [WSF_UPLOADED_FILE]
      -- uploaded files values
      --| filename: original path from the user
      --| type: content type
      --| tmp_name: path to temp file that resides on server
      --| tmp_base_name: basename of `tmp_name'
      --| error: if /= 0 , there was an error : TODO ...
      --| size: size of the file given by the http request
```
to iterate over the uploaded files if any, and the details in the class [WSF_UPLOADED_FILE].

The following snipet code show how to work with Uploaded files using EWF [WSF_REQUEST] class, in the example
we build a simple html answer with basic information, if there is not uploaded files, we send a 400 status code
and a simple message.

```eiffel

  if  req.path_info.same_string ("/upload") then
            -- Check if we have an uploaded file
          if req.has_uploaded_file then
              -- iterate over all the uploaded files
            create l_answer.make_from_string ("<h1>Uploaded File/s</h1><br>")
            across  req.uploaded_files as ic loop
              l_answer.append ("<strong>FileName:</strong>")
              l_answer.append (ic.item.filename)
              l_answer.append ("<br><strong>Size:</strong>")
              l_answer.append (ic.item.size.out)
              l_answer.append ("<br>")
            end
            res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-type","text/html"],["Content-lenght", l_answer.count.out]>>)
            res.put_string (l_answer)
          else
              -- Here we should handle unexpected errors.
            create l_answer.make_from_string ("<strong>No uploaded files</strong><br>")
            create l_answer.append ("Back to <a href='/'>Home</a>")
            res.put_header ({HTTP_STATUS_CODE}.bad_request, <<["Content-type","text/html"],["Content-lenght", l_answer.count.out]>>)
            res.put_string (l_answer)
          end
    else
          -- Handle error
    end
```
The source code is available on Github. You can get it by running the command:

```git clone https://github.com/EiffelWebFramework/ewf.git```

The example is located in the directory $PATH/ewf/doc/workbook/upload_file where $PATH is where you run git clone.


<a name=examples>
## Examples
The source code is available on Github. You can get it by running the command:

```git clone https://github.com/EiffelWebFramework/ewf.git```

The GET example is located in the directory $PATH/ewf/doc/workbook/form/get, and the post example is located in the directory $PATH/ewf_examples/workbook/form/post where $PATH is where you run git clone . To run open it using Eiffel Studio or just run theg following command

```estudio -config  <ecf_name>.ecf -target <target_name>```

>Note: replace <ecf_name> and<target_name> with the corresponding values.


Nav: [Workbook](../workbook.md) | [Basic Concepts] (/doc/workbook/basics/basics.md) | [Handling Requests: Header Fields](/doc/workbook/handling_request/headers.md) 

