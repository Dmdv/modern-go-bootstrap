# Modern Go Application Bootstrap

This is a stripped version of   
https://github.com/Dmdv/modern-go-application  
I removed the sample application to keep it clean for further development  

I will be enriching this project with less overengineering practices compared to the original template.



**Go application boilerplate and example applying modern practices**

This repository tries to collect the best practices of application development using Go language.
In addition to the language specific details, it also implements various language independent practices.

Some areas Modern Go Application touches:

- architecture
- package structure
- building the application
- testing
- configuration
- running the application (e.g. in Docker)
- developer environment/experience
- telemetry

To help adopt these practices, this repository also serves as a boilerplate for new applications.


## Features

- configuration (using [spf13/viper](https://github.com/spf13/viper))
- logging (using [logur.dev/logur](https://logur.dev/logur) and [sirupsen/logrus](https://github.com/sirupsen/logrus))
- error handling (using [emperror.dev/emperror](https://emperror.dev/emperror))
- metrics and tracing using [Prometheus](https://prometheus.io/) and [Jaeger](https://www.jaegertracing.io/) (via [OpenCensus](https://opencensus.io/))
- health checks (using [AppsFlyer/go-sundheit](https://github.com/AppsFlyer/go-sundheit))
- graceful restart (using [cloudflare/tableflip](https://github.com/cloudflare/tableflip)) and shutdown
- support for multiple server/daemon instances (using [oklog/run](https://github.com/oklog/run))
- messaging (using [ThreeDotsLabs/watermill](https://github.com/ThreeDotsLabs/watermill))
- MySQL database connection (using [go-sql-driver/mysql](https://github.com/go-sql-driver/mysql))
- ~~Redis connection (using [gomodule/redigo](https://github.com/gomodule/redigo))~~ removed due to lack of usage (see [#120](../../issues/120))

### Load generation

To test or demonstrate the application it comes with a simple load generation tool.
You can use it to test the example endpoints and generate some load (for example in order to fill dashboards with data).

Follow the instructions in [etc/loadgen](etc/loadgen).

## Inspiration

See [INSPIRATION.md](INSPIRATION.md) for links to articles, projects, code examples that somehow inspired
me while working on this project.
