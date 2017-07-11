# Change in Rails Application that uses AJAX POST and redirecto_to between turbolinks 2.5.3 and turbolinks 5.0.1

Some Rails application, like this one, require saving automatically a 
form while the user is filling it, but continue allowing the user to edit.
This was simpler to do with Turbolinks 2.5.3, therefore an application could 
keep using turbolinks 2.5.3 but there would be problems to update to 
Rails 5.1 (since turbolinks 2.5.3 uses ```before_filter``` deprecated in favor
of ```before_action```). Anyway there are solutions with Turbolinks 5.0 
although not very well documented. 

This simple application has one form with 2 tabs and some fields in each tab.
It is expected that the form will save automatically when the user changes 
from one tab to the other (by sending with AJAX and POST the form to the
rails controller).

It works as expected using turbolinks 2.5.3.
However with turbolinks 5.0.1 when the user changes to the second tab the form
will be saved but the user will be redirected to the show page as would 
happen when the user pushes the submit button (making it impossible to fill the 
field in the second tab).

# REPRODUCING THE PROBLEM

To see the application working with turbolinks 2.5.3:

- Clone this repository
```
git clone  https://github.com/vtamara/turbolinks_prob50.git
```
- Launch server
```
	cd turbolinks_prob50
	bundle install
	rails db:setup
	rails s 
```
- Open the form in a browser at http://127.0.0.1/model1s/new
- You will see the form with two tabs (one field in the first one and two in 
  the second)
![tab1](https://raw.githubusercontent.com/vtamara/turbolinks_prob50/master/doc/tab1.png)

- When you change to the second tab, you will see that the server answers
  to an AJAX request by updating the model, and the user can continue
  filling the fields of the second tab
![tab2](https://raw.githubusercontent.com/vtamara/turbolinks_prob50/master/doc/tab2.png)

To see the problem with turbolinks 5.0.1:
- In the sources edit Gemfile and change the line
```
	gem 'turbolinks', '2.5.3'
```
  with
```
	gem 'turbolinks', '5.0.1'
```
- Update
```
	bundle update turbolinks
	bundle install
```
- Launch server
```
	rails s
```
- Open in the browser <http://127.0.0.1/model1s/new> and try to click on the
  link of the second tab
- You will be redirected to the show page
![show](https://raw.githubusercontent.com/vtamara/turbolinks_prob50/master/doc/show.png)

# PROBLEM

Using turbolinks 2.5.3 the sequence of requests done by the browser when
the user clicks on the link of the second tab is:
![requests-turbolinks2-5-3](https://raw.githubusercontent.com/vtamara/turbolinks_prob50/master/doc/requests-turbolinks2-5-3.png)

Using turbolinks 5.0.1 the sequence of requests is different:
![requests-turbolinks5-0-1](https://raw.githubusercontent.com/vtamara/turbolinks_prob50/master/doc/requests-turbolinks5-0-1.png)

Checking more closely the README of turbolinks, it says:

>> Instead of submitting forms normally, submit them with XHR. In 
>> response to an XHR submit on the server, return JavaScript that 
>> performs a Turbolinks.visit to be evaluated by the browser.
>>
>> The Turbolinks Rails engine performs this optimization automatically 
>> for non-GET XHR requests that redirect with the redirect_to helper.

And checking the source code of the gem turbolink-rails (v5.0.1), we notice 
that it interceps  ```redirect_to```:
<https://github.com/turbolinks/turbolinks-rails/blob/master/lib/turbolinks/redirection.rb>
and by default it replaces the page in the browser when the xhr request is not 
GET.

Checking the source code, we see a new option for ```redirect_to```, 
it is ```turbolinks``` that is boolean (I have not found official 
documentation for it).


# SOLUTIONS

In order to obtain the same behavior of Turbolinks 2.5.3 in 
Turbolinks 5.0.1  we have found two ways:

1. Either in the controller ```app/controllers/model1s_controller.rb```
   change in the method update the line:
```
format.html { redirect_to @model1, notice: 'Model1 was successfully updated.' }
```
with
```
format.html { redirect_to @model1, notice: 'Model1 was successfully updated.', turbolinks: false }
```


2. Or make the AJAX request asking for json (or script or xml) instead of HTML, 
   by changing in ```app/assets/javascripts/model1s.coffe```
```
@send_form =  ->
  f=$('form')
  a=f.attr('action')
  $.post(a, f.serialize())
```
with
```
@send_form =  ->
  f=$('form')
  a=f.attr('action')
  $.ajax({
    type: 'POST',
    url: a,
    data: f.serialize()
    dataType: 'json'
  });
```

The second solution uses the format.json of the action in the controller
```app/controllers/model1s_controller.rb```, and returns the model in
JSON.  If no response is needed it is possible to use:
```
	format.json { head :no_content }
```


Then to obtain the increase of speed of turbolinks in a normal redirect_to 
when the users saves but avoiding to redirect in the browser when
the form is saved automatically, we  prefer the second solution.


