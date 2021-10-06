Micro service app and Dockerfile to build docker image 

This is micro service python 3.9 
the app.py run on port 80 and local machin ip
the script answer and count GET request 

Example command to buld and run: 
<pre>
docker build -t app:1.0 .
docker run --name app-alpine -p 80:5000 app:1.0.0
</pre>

Example command to check: 
<pre>
import requests

response = requests.get("http://your-local-ip/count")
print(response.json())
