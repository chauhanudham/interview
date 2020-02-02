# Description
You are required to perform the following:
* Spin up a [Jenkins](https://jenkins.io/) instance
* Configure to trigger a Build on commit
* Use Jenkinsfile to achieve the following:
    * Pull a Python app from this repo (spinning-spindle/lab-devops)
    * Dockerize the app `hello_world.py`
    * Publish docker image to dockerhub (use your own temporary account)
* Spin up an [Ansible](https://www.ansible.com/) instance
   * Provision the image you created above, on your local machine
* Make sure you take the necessary precautions regarding security when you deploy in order to expose the application only on localhost

# Bonus:
* Improve the the above setup by considering the use of SSL certificates
* How to provisioning better using docker-compose or kubernetes and why do that?
* Create a staging environment for running integration tests as part of the build process and publish results to jenkins job

# Providing your contribution
* Create a pull-request on this repository that contains, the following:
  * for Jenkins, an export of the Job
  * for Ansible, the playbook
  * any other files you deem necessary
  * a Markdown README, with a narrative of the approach taken. Consider the following:
      - What principles did you apply?
      - Explain the decisions you made and why you thought it was the best approach
      - If you ran out of time, how did you envision your finished infrastructure?
      - What is your recommendation for any future work?
