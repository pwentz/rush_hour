# Rush Hour
__Completed by: Patrick Wentz, Garrett Smestad, and Zachary Forbing__

----

## Project Overview

Rush Hour is an application that aggregates and analyzes visitor data from another website. A Rush Hour customer/client will embed JavaScript in their website that will gather and send their visitor data to our site. It is important to note that we did not create this JavaScript. Instead, we simulated the process of gathering and receiving data, which we call a "payload." The Rush Hour application can accept the submission of these payloads, analyze the data submitted, and display it through an HTML interface.

### Learning Goals

* Understand how web traffic works
* Dig into HTTP concepts including headers, referrers, and payload
* Design a normalized SQL-based relational database structure
* Use ActiveRecord to interface with the database from Ruby
* Practice fundamental database storage and retrieval
* Understand and practice HTTP verbs including GET, PUT, and POST
* Practice using fundamental HTML and CSS to create a usable web interface

----

## Key Concepts

### Payloads

We will use pre built payloads to simulate the gathered data from a customer/client's website. The payloads are in a hash-like format called JSON, and look like this:
```ruby
payload = {
  "url":"http://jumpstartlab.com/blog",
  "requestedAt":"2013-02-16 21:38:28 -0700",
  "respondedIn":37,
  "referredBy":"http://jumpstartlab.com",
  "requestType":"GET",
  "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
  "resolutionWidth":"1920",
  "resolutionHeight":"1280",
  "ip":"63.29.38.211"
}
```
Rush Hour simulates sending these requests using a cURL command from the terminal, which sends an HTTP request. You can checkout the details of the cURL command by running `curl --manual` in your terminal.

### Concept2

*[Insert Concept2 description/explanation here]*

### Concept3

*[Insert Concept3 description/explanation here]*

----

## Project Iterations and Base Expectations

Because the requirements for this project are lengthy and complex, we've broken them into iterations:

* [Iteration 0](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-0)
* [Iteration 1](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-1)
* [Iteration 2](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-2)
* [Iteration 3](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-3)
* [Iteration 4](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-4)
* [Iteration 5](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-5)
* [Iteration 6](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-6)
* [Iteration 7](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-7)
* [Iteration 8](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md#iteration-8)

----

## Appendix

The full project instructions can be found [here](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md).

## Post-Project Group Retro

our group retro markdown can be found [here](https://gist.github.com/zackforbing/abb77a9b647402fa199c3b7335eef116).
