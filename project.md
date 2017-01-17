
##Project Overview##

You will take a baseline installation of a Linux distribution on a
virtual machine and prepare it to host your web applications, to
include installing updates, securing it from a number of attack
vectors and installing/configuring web and database servers.

###Why this Project?###

A deep understanding of exactly what your web applications are doing,
how they are hosted, and the interactions between multiple systems are
what define you as a Full Stack Web Developer. In this project, you’ll
be responsible for turning a brand-new, bare bones, Linux server into
the secure and efficient web application host your applications need.

###What will I Learn?###

You will learn how to access, secure, and perform the initial
configuration of a bare-bones Linux server. You will then learn how to
install and configure a web and database server and actually host a
web application.

###How does this Help my Career?###

  * Deploying your web applications to a publicly accessible server is
    the first step in getting users

  * Properly securing your application ensures your application
    remains stable and that your user’s data is safe



## Project Details ##

How will I complete this project?

This project is linked to the [Configuring Linux Web Servers](https://classroom.udacity.com/courses/ud299)
course.

  - Launch your Virtual Machine with your Udacity account. Please note that upon graduation from the program your free Amazon AWS instance will no longer be available.
  - Follow the instructions provided to SSH into your server
  - Create a new user named grader
  - Give the grader the permission to sudo
  - Update all currently installed packages
  - Change the SSH port from 22 to 2200
  - Configure the Uncomplicated Firewall (UFW) to only allow incoming connections for SSH (port 2200), HTTP (port 80), and NTP (port 123)
  - Configure the local timezone to UTC
  - Install and configure Apache to serve a Python mod_wsgi application
  - Install and configure PostgreSQL:
    * Do not allow remote connections
    * Create a new user named catalog that has limited permissions to your catalog application database
  - Install git, clone and setup your Catalog App project (from your
    GitHub repository from earlier in the Nanodegree program) so that
    it functions correctly when visiting your server’s IP address in a
    browser. Remember to set this up appropriately so that your .git
    directory is not publicly accessible via a browser!

You may also find this
[Getting Started Guide](https://docs.google.com/document/d/1J0gpbuSlcFa2IQScrTIqI6o3dice-9T7v8EDNjJDfUI/pub?embedded=true)  helpful when working on Project 5.

## Webcasts for the Linux Server Configuration Project ##

Need some additional help getting started with the Linux Server
Configuration Project, or simply curious and want to learn a little
bit more? Watch the following Webcasts!

These webcasts are recordings of live Q&A sessions and demos. As
always, you should read the appropriate rubric for your project
thoroughly before you begin work on any project and double check the
rubric before submitting. The videos were made by Udacity's
coaches. Think of them as extra supplemental materials.

The webcasts for the Linux Server Configuration Project include:

 * [SSH and the Udacity development environment](https://www.youtube.com/watch?v=HcwK8IWc-a8)
 * [Working with a remote server](https://www.youtube.com/watch?v=HcwK8IWc-a8)
 * [Intro to TMux](https://www.youtube.com/watch?v=hZ0cUWWixqU)
 * [Deploying a Flask App with Heroku](https://www.youtube.com/watch?v=5UNAy4GzQ5E)

Happy Learning!