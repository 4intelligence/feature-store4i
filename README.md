# Featurestore - R Package

<p align="center">
  <img src="https://avatars.githubusercontent.com/u/62453560?s=200&v=4" width="125px"/><br><br>
  <img src="https://img.shields.io/badge/4i-4intelligence-blue"/>
  <img src="https://img.shields.io/badge/R%3E%3D-4.0.3-blue.svg"/>
  <img src="https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg"/>
</p>

Repository to access data in Feature Store's database. It is completely dependent on FS-API and works like a wrapper to the API.

## Installation

You can install the package using the function `install_github` from `devtools`. However this is a private repository, so you also need to generate a personal token from GitHub, just access this [link](https://github.com/settings/tokens) and follow the instructions.

```
devtools::install_github("4intelligence/feature-store4i", force = TRUE)
```

You can also install the package by downloading the file `.tar.gz` from releases in this repository and performing the install in RStudio.

## Authentication
Each user will need to set up the authentication using the function login. The function login will display a URI where 4CastHub's user email and password will be required, as well as the two-factor-authentication code.

```
fs4i::login()
## Once the URL is printed, copy and paste it to your browser and follow with authentication
```

## Basic Usage

### Get Serie

This function allows you to get series from Featurestore, it is necessary two parameters:
* serie_code: A string with serie's code to fetch
* estimate: A logical value to determine with the projection will be included
The answer is a list with two data frames, the first one is the data from serie and the second one is the metadata from serie.

#### Example:

```
response <- fs4i::get_serie("AREMP0085000OOQL", TRUE)
```

### Get Multi Series

This function allows you to retrieve many series from Featurestore, it works just like `get_serie`, however, the first parameter (series_code) must be a list.

#### Example:

```
response <- get_multi_series(c("AREMP0085000OOQL", "BRBOP0044000OOML"), FALSE)
```
