## Minimal Docker Compose Setup for Frappe for App Development

Didn't like the official one. Made my one. :)  
There can potentially be missing packages etc. as of now it works for my use case.

After running `docker compose up` you need to `docker compose exec backend bash` and create a new site called "localhost".
The command for that is in the "new-site-localhost.sh" file.

Then draw the rest of the owl while creating your custom app.
