# File Exchange Hub

A platform for exchanging files across different services, including an Express server, a Socket.IO server, a file gateway, and a client.

## Table of Contents

- [File Exchange Hub](#file-exchange-hub)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [Usage](#usage)
  - [Testing](#testing)
  - [Deployment](#deployment)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Node.js](https://nodejs.org/) (v14 or later)
- [Docker](https://www.docker.com/)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads.html)

### Installation

1. Clone the repository:

```
git clone https://github.com/rafaelxokito/fileexchangehub.git
cd fileexchangehub
```

2. Install the dependencies for each service:

```
cd client && npm install
cd ../server && npm install
cd ../socket-server && npm install
cd ../file-gateway && npm install
cd ..
```

3. Create a `.env` file in the `server`, `socket-server`, and `file-gateway` directories with the required environment variables.

## Usage

1. Start the services:

```
cd client && npm start
cd ../server && npm start
cd ../socket-server && npm start
cd ../file-gateway && npm start
cd ..
```


2. Access the client at `http://localhost:3000`.

## Testing

To run the test suite for each service:

```
cd client && npm test
cd ../server && npm test
cd ../socket-server && npm test
cd ../file-gateway && npm test
cd ..
```


## Deployment

This project uses GitHub Actions and Terraform to deploy to Google Cloud Run. Refer to the workflow file `.github/workflows/deploy.yml` for more details on the deployment process.