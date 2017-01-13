## Scripts

### harvest_check.py

Run `pip install -r requirements.txt`, then `python harvest_check.py`

Checks all days in the previous week in harvest, and sends an email if you haven't logged enough hours on any day.

To use, you need to setup a [mailgun](http://www.mailgun.com/) account, and create a `config.py` file with these fields:

| Field | Description |
| ----- | ----------- |
| min_hours | The minimum acceptable amount of hours logged in a day |
| email | The address to send the warning email to |
| harvest_url | The url for harvest |
| mailgun_secret_key | The secret key for mailgun |
| mailgun_public_key | The public key for mailgun |
| mailgun_domain | The domain for mailgun |
| harvest_user | Username/email for harvest |
| harvest_password | Password for harvest |

### update-lodash-imports.clj

Updates all the `.ts*` files in the given directory to import each individual lodash function separately.

Open the file in a repl, and run `fix-lodash`, passing in the absolute path to the directory where your code is.
