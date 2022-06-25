# Mutual Book Exchange Portal

This Mutual Book Exchange Portal is a Web-based Application that enables the registered 
users to exchange books they have with them, free of cost, for the purpose of temporary use, and 
return.

Note : This repository contains both frontend and backend code.

## Installation

### Backend(Java)

Dependencies :

* [Java 18](https://www.oracle.com/java/technologies/downloads/)
* [MongoDB](https://www.mongodb.com/try/download/community)
* [Maven](https://maven.apache.org/install.html)

In the root folder run

```java
mvn clean package
java -jar library-backend.jar
```
---

### Frontend(Flutter)

Dependencies :

* [Flutter](https://docs.flutter.dev/)
* [Docker](https://docs.docker.com/)

In the root folder run

```dart
flutter run -d chrome
```

**Build the docker image** 

Use docker to build the container image
```
docker build . -t library-web-app
```
If you have some problem during cache, you can clean cache by this
```
docker build . --no-cache -t library-web-app
```

**After successfully building the image**

Run the docker image with localhost 8888 port. You can change to any other port just replace it.
```
docker run -d -p 8888:80--name libraryweb library-web-app
```

Here we go, open browser and go to http://localhost:8888/


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
