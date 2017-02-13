A Docker image with:

* Ubunut 16.04
* Chrome
* Chromedriver
* Xvfb
* Rvm
* Npm
* Python

Built for testing ruby / cucumber / selenium and node server apps.

### Building
```
docker build -t chrome .
```

### Deploying to docker hub

```
docker tag chrome coder36/chrome
docker push coder36/chrome
```


### Pulling from docker  - [https://hub.docker.com/r/coder36/chrome](https://hub.docker.com/r/coder36/chrome)
```
docker run -t -i coder36/chrome

```


### Example `.gitlab-ci.yml`
```
image: "coder36/chrome"

stages:
  - cucumber

cache:
  paths:
    - vendor
    - node_modules
cucumber:
  stage: cucumber
  script:
  - rvm use 2.2.3
  - ruby -v                                     
  - gem install bundler  --no-ri --no-rdoc    
  - bundle install -j $(nproc) --path vendor 
  - npm install
  - npm start &
  - sleep 10 
  - export DISPLAY=:99
  - /etc/init.d/xvfb start
  - bundle exec cucumber --format html --out cucumber.html --format pretty --format json --out tests.cucumber
```
