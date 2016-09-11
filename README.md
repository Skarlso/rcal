# Ruby Calendar (rcal)

A small tool for a CLI calendar with Google Integration.

To install the gem for testing, run `bundle install && rake install`.

After that, the bin should work just fine.

Notes: Anything is included that is listed by `git ls-files`.

# Google Integration

This Gem will not be a multiuser gem. It is intended to be used by a single user in his/her own environment.

It does use Redis to store the user's authorisation token, and it does use CSRF protection via generated token matching, but that is all it does.

Your applications credentials must be stored in a file next to this application as `creds.json`. And your user_id variable which is used in the store to store your user_id is in a file called `user_id` in the root of this project along with creds.json.
