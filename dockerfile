FROM python:2.7
MAINTAINER Udham Singh "chauhanudham07@gmail.com"
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["hello_world.py"]
