# AWS Serverless Weather Application

## Overview

This is a fully serverless weather application built using AWS.

The frontend is hosted on Amazon S3 Static Website Hosting.

The backend is powered by AWS Lambda and exposed through Amazon API Gateway.

The Lambda function fetches live weather information from the OpenWeatherMap API and returns JSON to the frontend.

---

## AWS Services Used

- Amazon S3
- AWS Lambda
- Amazon API Gateway
- IAM

---

## Architecture

Browser

↓

S3 Static Website

↓

API Gateway

↓

Lambda Function

↓

OpenWeatherMap API

---

## Features

- Search any city
- Live Temperature
- Humidity
- Wind Speed
- Weather Description
- Error Handling
- Responsive UI

---

## Deployment

1. Create S3 bucket
2. Enable Static Website Hosting
3. Upload frontend
4. Create Lambda
5. Create API Gateway
6. Enable CORS
7. Deploy API
8. Update API URL inside config.js
