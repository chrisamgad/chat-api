# Chat APIs App

This repository contains the code for a RESTful API to manage a chat system built using Ruby on Rails. It allows creating new applications, managing chats within applications, and sending messages within chats. Additionally, it includes an endpoint for searching through messages of a specific chat using ElasticSearch. The app also makes use of Redis as an extra layer of caching behind mySQL to optimize performance. The API is containerized using Docker and can be easily deployed using docker-compose up.

## Technologies Used
- Ruby v3.0.6
- Rails
- MySQL
- Redis
- RabbitMQ
- Elasticsearch
- Sneakers (background workers)
.
## Ports required
Please make sure before deploying that the following ports are avalable:
 - 3000 - Rails app
 - 3307 - MySQL
 - 6379 - Redis
 - 5672 - RabbitMQ
 - 9200 - Elasticsearch

## Instructions to Run
To run the whole stack, follow these steps:
 1. Clone this repository:
  ```
  git clone https://github.com/chrisamgad/chat-api.git
  ```
 2. Navigate to the project directory:
  ```
  cd chat-api
  ```
 3. Build and run the Docker containers:
  ```
  docker-compose up
  ```
 4. Wait for the docker containers to run and then when they're done, you will be able to access the api via <b>http://localhost:3000</b>


## API Endpoints

|  | Endpoint |
| --- | --- |
| **POST** | /api/v1/applications |
| Description | Creates a new application with the provided name in the body|
| **GET** | /api/v1/applications/`:application_token` |
| Description | Retrieves information about a specific application identified by its token |
| **GET** | /api/v1/applications |
| Description |  Retrieves information about all applications|
| **PATCH** | /api/v1/applications/`:application_token` |
| Description | Updates the name of the application identified by its token|
| **POST** | /api/v1/applications/`:application_token`/chats |
| Description | Creates a new chat within the specified application |
| **GET** | /api/v1/applications/`:application_token`/chats |
| Description | Retrieves a list of chats belonging to the specified application|
| **GET** | /api/v1/applications/`:application_token`/chats/`:chat_number` |
| Description | Retrieves information about a specific chat within the specified application|
| **POST** | /api/v1/applications/`:application_token`/chats/`:chat_number`/messages |
| Description |  Adds a new message to the specified chat within the specified application |
| **GET** | /api/v1/applications/`:application_token`/chats/`:chat_number`/messages |
| Description | Retrieves a list of messages within the specified chat|
| **GET** | /api/v1/applications/`:application_token`/chats/`:chat_number`/messages/`:message_number` |
| Description | Retrieves information about a specific message within the specified chat |
| **PATCH** | /api/v1/applications/`:application_token`/chats/`:chat_number`/messages/`:message_number`  |
| Description | Updates the content of a specific message within the specified chat |
| **GET** | /api/v1/applications/`:application_token`/chats/`:chat_number`/messages/search |
| Description | Searches for messages within the specified chat, allowing partial matches on message bodies |

## Quick reflection
I managed to pull off this project even though I hadn't touched Ruby before. I dove in headfirst, relying on my experience with other programming languages. Turns out, picking up Ruby wasn't as tough as I thought! However, since I'm new to Ruby, I might have missed some of the best practices of the framework. Nonetheless, this project showcases my knack for learning on the fly and tackling new stuff.

## Architecture
I opted for a service-oriented architecture (SOA) to facilitate modularity and scalability within the system. This architecture comprises various services tailored to specific functionalities, including a cache service, a search service, and resource creators/getters. By adopting an SOA approach, each service operates independently, allowing for easier maintenance and updates. Additionally, this architecture fosters flexibility, enabling seamless integration of additional services as the system evolves

## Extra caching layer
I integrated Redis as a caching layer alongside MySQL, the primary database. Redis acts as a cache, enhancing data retrieval speed. If a requested record isn't found in MySQL, Redis is utilized to cache the data. This setup optimizes performance by minimizing repetitive database queries, resulting in faster response times. By incorporating Redis caching, I ensured efficient handling of data requests, improving the overall responsiveness of the chat system API.

## The lifecycle of a chat instance (messages follow a similar process)
During the chat creation process, a unique approach was implemented to manage data flow. Instead of directly persisting chats to MySQL, they were temporarily encoded as JSON objects. To dynamically generate chat numbers, a custom generation service was developed. This service relied on a Redis-stored key, chats_count, unique to each application. Upon chat creation, this key was accessed and incremented accordingly.

Moreover, to ensure data integrity amidst concurrent requests, a distributed Redis Mutex was employed. This safeguarded against race conditions that could arise when multiple requests attempted to read and increment the chats_count for a given application simultaneously.

This methodology ensured that each chat received a distinct number within its application context, all without direct MySQL interaction during creation. Upon successful number generation, it was returned in the response. Additionally, the encoded JSON object was published to a chats queue for processing by background workers (Sneakers).

These workers were tasked with persisting the records in the database. As each job was consumed from the queue, the worker decoded the chat and applied a row-level pessimistic lock on the parent application instance to increment its chats_count. This mechanism effectively prevented race conditions in the database. Subsequently, the application, including its updated chats_count, was cached for optimized performance.

## What to enhance?
 - There are numerous algorithms and analyzers available in Elasticsearch that could potentially enhance the search functionality for specific use cases. However, due to time constraints, the standard analyzer was chosen, which should suffice for most general use cases. It would be beneficial to conduct thorough testing of different algorithms and analyzers to determine the most suitable configuration for optimizing search performance and accuracy.
 - Furthermore, while caching mechanisms have been implemented for fetching single resources, such as retrieving a single message, chat or application, caching for bulk resource retrieval, including applications, chats, and messages, remains pending. Due to time constraints, this optimization was not fully realized. Implementing caching for bulk resource retrieval could significantly enhance overall system performance and scalability, reducing latency and improving response times, especially during periods of high traffic or frequent data access. This enhancement would minimize latency and boost response times, particularly during peak usage or frequent data access scenarios.


