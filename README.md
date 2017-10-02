## Scripts

### harvest_check.hy

Install Hy, run `pip install -r requirements.txt`, then run `hy harvest_check.hy`

Checks all days in the previous week in harvest, and sends a slack message if you haven't logged enough hours on any day.

The following must be present in `config.hy`:

| Var   | Description |
| ----- | ----------- |
| harvest-config | A map containing the `:url`, `:email`, and `:password` keys |
| slack-config   | A map containing the `:token` (slack app oauth token) and `:user-id` (slack user _id_, not name) keys |

### update-lodash-imports.clj

Updates all the `.ts*` files in the given directory to import each individual lodash function separately.

Open the file in a repl, and run `fix-lodash`, passing in the absolute path to the directory where your code is.
