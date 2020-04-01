# Challenge Swift
This repository have been created with the aim of showing our first work using Swift.


### Authors

* **José João Silva** - [jjoaosilva](https://github.com/jjoaosilva/)
* **Alley Pereira** - [All3yp](https://github.com/All3yp/) 

>We are students and we are scholarships holders at Apple Developer Academy on IFCE.

## How to use

### Xcode project
You can clone project using:

`git clone https://github.com/jjoaosilva/challengeSwift.git`

After that, you will need to create a key accessto access the API. You can create an account at [The New York Times Developer Network](https://developer.nytimes.com) and use [Article Search API](https://developer.nytimes.com/docs/articlesearch-product/1/overview) in your application. So, you have two possibilities:

>* You can creates an environment variable in your Xcode Project: **Product** -> **Scheme** -> **Edit Scheme...** -> **Environment Variables** with this format: **(Name: "API", Value: "Your key access")**
>
>* You can create a file with the name: **"apiKey.json"** and in there put: **{
"key":"Your key access" }**

After that, open this project in Xcode and have fun! Executing the code, you will see anything like this: 

```
Welcome to BashNews!

Enter your search: 
```

Here you can write about whatever you want! It's important you know that all things written are researched in **New York Times's API**.

Exemple:
```
Welcome to BashNews!

Enter your search: corona virus


Today's news: 2020-04-01

Article: Charlie Campbell, nearly 13 years sober, is feeling tested today more than ever to stay that way.  

Stretch: Charlie Campbell, nearly 13 years sober, is feeling tested today more than ever to stay that way.   

Font:  https://www.nytimes.com/aponline/2020/04/01/health/ap-us-med-virus-outbreak-addiction.html  
```

### Script bash

You can paste the file Structs.swift at the beginning of the file main.swift and in the other file script.swift put them.

**Note** : remember write in the first line `#!/usr/bin/swift`

After that, you cant create a **.zshrc** file with this content:

```
alias bashNews="swift /Your_Directory/script.swift"

bashNews
```
With this, you can run in your terminal:

`source .zshrc`

and

`bashNews`

## About pull requests
We are open to suggestions and hope to learn frmo each PR.
