# Ruby Calendar (rcal)

A small tool for a CLI calendar with Google Integration.

To install the gem for testing, run `bundle install && rake install`.

After that, the bin should work just fine.

# Google Integration

This Gem will not be a multiuser gem. It is intended to be used by a single user in his/her own environment.

It does use Redis to store user authorizaiton tokens, and it does use CSRF protection via generated token matching, but that is all it does.

Your applications credentials must be stored in a file next to this application or as an environment variable. That is up to you. 
