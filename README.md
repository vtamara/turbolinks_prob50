# Change in jquery post by using turbolinks 2.5.3 and turbolinks 5.0

This simple application has one form with 2 tabs and one field in each tab.
It is expected that the form will save automatically when the user changes 
from one to the other (by sending with AJAX and POST the form to the
rails controller).

It works as expected using turbolinks 2.5.3.
However with turbolinks 5.0.3 when the user changes to the second tab the form
will be saved but the user will be redirected to the show page (making it
impossible to fill the field in the second tab).

To see the application working with turbolinks 2.5.3:

- Clone this repository
	git clone https://github.com/vtamara/turbolinks-prob50.git
- Launch server
	cd turbolinks-prob50
	bundle install
	rails s 
- Open the form in browser in http://127.0.0.1/model1s/new
- You will see a form with two tabs (there is one field in each tab)
- When you change to the second tab, you will see that the server answers
  an AJAX request to save the form, and the user sees the contents of the
  second tab


To see the problem with turbolinks 5.0.3:
- In the sources edit Gemfile and change the line
	gem 'turbolinks', '2.5.3'
  with
	gem 'turbolinks', '5.0.3'
- Update
	bundle update turbolinks
	bundle install
- Launch server
	rails s
- Open in browser http://127.0.0.1/model1s/new and try to click on the
  link of the second tab
- You will be redirected to the show page


Using turbolinks 2.5.3 the sequence of requests done by the browser when
the user clicks on the link of the second tab is:
[!requests-turbolinks2-5-3](requests-turbolinks2-5-3.png])

Using turbolinks 5.0.3 the sequence of requests is:
[!requests-turbolinks5-0-3](requests-turbolinks5-0-3.png])
