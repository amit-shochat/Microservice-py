FROM python:3.7.3-alpine3.9 as builder

# Make worker DIR and force work ENV
RUN mkdir /work/
WORKDIR /work/

#COPY all all file to container work dir
COPY ./app.py /work/app.py
COPY ./requirements.txt /work/requirements.txt

# install all the pack's
RUN pip install -r requirements.txt

#PORT
EXPOSE 80

#RUN command for app
CMD [ "python", "./app.py" ]
