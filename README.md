# Coding Assignment.
## Implement the Minimum Viable Product (MVP) according to the requirements:

### Functional requirements
- Must be done in Ruby on Rails
- Accept an address as input
- Retrieve forecast data for the given address. This should include, at minimum, the current temperature
(Bonus points - Retrieve high/low and/or extended forecast)
- Display the requested forecast details to the user
- Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if
result is pulled from cache.

### Non Functional requirements
- Availability
- Scalability
- Reliability
- Maintainability
- Usability

## Solution

### High level system design



### Compliance with the functional requirements

- The application is developed using Ruby version `3.2.2` and Rails version `7.0.6`, ensuring compatibility with
the latest language and framework releases.

- When accessing the `/forecasts` page, users are presented with a form featuring an input field to enter
the zip code.

- The application retrieves the current temperature in Fahrenheit based on the provided zip code.

- To provide real-time updates, the temperature is displayed through a `WebSocket` connection and dynamically
shown in the `.forecast-results` div on the page. This allows users to receive immediate updates without
needing to manually refresh the page.

- `Redis`, a database technology, is utilized for storing previously retrieved data. If the requested data is
available in the cache, the user is presented with a label in the color `#055160` indicating that the data was
retrieved from the cache. This ensures efficient retrieval and reduces the need for repetitive data fetching.

### Compliance with the non functional requirements

- The system ensures accessibility by utilizing a message queue, allowing asynchronous and ordered processing
of user requests. To meet the MVP requirements and optimize development time and reliability, `Sidekiq` in
conjunction with `Redis` was chosen as the primary technology stack.

- The application architecture is designed to provide high-level extensibility, both horizontally and
vertically, within the asynchronous server component. Currently, Sidekiq is utilized as the asynchronous
server solution. However, the architecture leverages `Active Job` as a wrapper, allowing for easy integration
with alternative asynchronous server options such as `RabbitMQ` or `Apache Kafka`. This design choice enhances the
reliability and stability of the application.

- The codebase follows the principles of the `Rate Limiter`, `Strategy`, and `Observer` patterns, which contribute
to a well-structured and maintainable codebase. These patterns help manage and control the rate of incoming
requests, define flexible strategies for handling different scenarios, and observe changes within the
application.

- Additionally, the architecture is designed to support future scalability for `mobile clients` or `API
provision`. This means that the application can easily accommodate the needs of mobile applications or expose
its functionality through an API, allowing for broader usage and integration possibilities.

- Overall, the architecture demonstrates a focus on extensibility, scalability, and adherence to established
design patterns to ensure a robust and flexible application foundation.  

- Redis, the non-relational database used for caching, can be easily scaled horizontally to accommodate
increased demand. `Redis Sentinel` can also be employed to enhance the reliability of `Redis` by introducing
additional database instances and setting up replications.

- To facilitate application maintenance, the codebase is developed with readability in mind, and comprehensive
documentation is provided for each class, clearly describing their functionality. This allows for easy
understanding and future reusability of system modules, enabling the system to adapt and support evolving
user cases.

- The codebase adheres to high-quality coding standards and follows the guidelines set by the `RuboCop` linter.
By formatting the code with `RuboCop`, the codebase maintains a consistent and standardized style, improving
readability and ensuring a unified code structure across the project. This adherence to a linter helps to
identify and enforce best practices, reducing potential coding errors and enhancing the maintainability of the
codebase. The `RuboCop` linter plays a crucial role in maintaining code quality and consistency throughout the
development process.

- Usability is a priority, demonstrated by the simple user interface featuring a straightforward form with
a `zip code` input. Users receive `real-time feedback` indicating that their request is being processed, and
once the processing is complete, they are presented with the relevant information on the same page without
any need for page reloading.

- In addition to the documentation, the codebase maintains a high test coverage percentage of `98.52%`. This
extensive test coverage ensures that the application's functionality is thoroughly tested, reducing the risk
of introducing bugs and providing confidence in the reliability of the system. The comprehensive test suite
serves as a safety net, enabling developers to make changes and refactor code with confidence, knowing that
they can catch regressions through automated tests.

