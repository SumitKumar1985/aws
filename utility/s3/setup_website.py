#!/usr/bin/env python

import yaml

configuration = yaml.load(open("config.yml", 'r'))

aws_region = configuration["aws_region"]
website = configuration["website"]
create_www = configuration["create_www"]

import boto

conn = boto.connect_s3()

conn.create_bucket(website, location=Location.EU)

if create_www:
	conn.create_bucket('www.' + website, location=Location.EU)
