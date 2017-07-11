# Change with AJAX POST and redirecto_to by using turbolinks 2.5.3 and turbolinks 5.0 in Rails Applications

Some rails application, like this one, require saving automatically a 
form while the user is filling it, but continue editing the form. 
This was simpler to do with Turbolinks 2.5.3

This simple application has one form with 2 tabs and some fields in each tab.
It is expected that the form will save automatically when the user changes 
from one tab to the other (by sending with AJAX and POST the form to the
rails controller).

It works as expected using turbolinks 2.5.3.
However with turbolinks 5.0.1 when the user changes to the second tab the form
will be saved but the user will be redirected to the show page as would 
happen when the user submits the form (making it impossible to fill the 
field in the second tab).

# REPRODUCING THE PROBLEM

To see the application working with turbolinks 2.5.3:

- Clone this repository
```
git clone  https://github.com/vtamara/turbolinks_prob50.git
```
- Launch server
```
	cd turbolinks-prob50
	bundle install
	rails db:setup
	rails s 
```
- Open the form in browser at http://127.0.0.1/model1s/new
- You will see a form with two tabs (one field in the first one and two in 
  the second)
[!tab1](tab1.png])

- When you change to the second tab, you will see that the server answers
  an AJAX request to save the form, and the user sees the contents of the
  second tab
[!tab2](tab2.png])


To see the problem with turbolinks 5.0.1:
- In the sources edit Gemfile and change the line
	gem 'turbolinks', '2.5.3'
  with
	gem 'turbolinks', '5.0.1'
- Update
	bundle update turbolinks
	bundle install
- Launch server
	rails s
- Open in browser http://127.0.0.1/model1s/new and try to click on the
  link of the second tab
- You will be redirected to the show page
[!show](show.png)

# PROBLEM

Using turbolinks 2.5.3 the sequence of requests done by the browser when
the user clicks on the link of the second tab is:
[!requests-turbolinks2-5-3](requests-turbolinks2-5-3.png])

Using turbolinks 5.0.1 the sequence of requests is different:
[!requests-turbolinks5-0-1](requests-turbolinks5-0-1.png])

The gem turbolink-rails (v5) is intercepting redirect_to:
<https://github.com/turbolinks/turbolinks-rails/blob/master/lib/turbolinks/redirection.rb>
and by default replacing the page when the xhr request is not GET.

# SOLUTION

Checking the source code it is possible to see a new option for
```redirect_to```, ```turbolinks``` that is boolean.

Then in order to obtain the same behavior of Turbolinks 2.5.3 in 
Turbolinks 5.0.1 in the controller app/controllers/model1s_controller.rb
change in the method update the line:
```
        format.html { redirect_to @model1, notice: 'Model1 was successfully updated.' }
```
with
```
        format.html { redirect_to @model1, notice: 'Model1 was successfully updated.', turbolinks: false }
```


