import harvest
import datetime
from mailgun2 import Mailgun
from config import min_hours, email, harvest_url, mailgun_secret_key, mailgun_public_key, mailgun_domain, harvest_user, harvest_password



today = datetime.date.today()
last_monday = today - datetime.timedelta(today.weekday() + 7)
client = harvest.Harvest(harvest_url, harvest_user, harvest_password)
mailer = Mailgun(mailgun_domain, mailgun_secret_key, mailgun_public_key)

last_monday_day_of_year = last_monday.timetuple().tm_yday
days_to_check = range(last_monday_day_of_year, last_monday_day_of_year + 5)
warning_days = []
for year_day in days_to_check:
    day_entries = client.get_day(year_day, today.year)["day_entries"]
    hours = map(lambda day: day["hours"], day_entries)
    total = sum(hours)
    print(total)
    print(total < min_hours)
    if total < min_hours:
        warning_days.append(year_day)

if warning_days:
    mailer.send_message(
        'harvest@{0}'.format(mailgun_domain),
        [email],
        subject='Harvest up to date for last week?',
        text='Update your bloody harvest you idiot -> {0}'.format(harvest_url)
        )
