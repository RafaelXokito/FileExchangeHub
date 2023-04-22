# File Exchange Hub

A platform for exchanging files across different services, including an Express server, a Socket.IO server, a file gateway, and a client.

## Table of Contents

- [File Exchange Hub](#file-exchange-hub)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [Usage](#usage)
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

3. Create the uploads directory in the `server`, and `file-gateway` service directories.

```
cd server && mkdir uploads
cd ../file-gateway && mkdir uploads
cd ..
```

## Usage

1. Start the services:

```
cd client && npm start
cd ../server && npm start
cd ../socket-server && npm start
cd ../file-gateway && npm start
cd ..
```

2. Access the client at `http://localhost:8080`.

## Deployment

This project uses GitHub Actions and Terraform to deploy to Google Cloud Run. Refer to the workflow file `.github/workflows/deploy.yml` for more details on the deployment process.