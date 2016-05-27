---
layout: default
title: Request
base_url: ../../../
---
See WSF_REQUEST

## About parameters
Note that by default there is a smart computation for the query/post/... parameters:
for instance
- `q=a&q=b` :  will create a **WSF_MULTIPLE_STRING** parameter with name **q** and value `[a,b]`
- `tab[a]=ewf&tab[b]=demo` : will create a **WSF_TABLE** parameter with name **tab** and value `{ "a": "ewf", "b": "demo"}`
- `tab[]=ewf&tab[]=demo` : will create a **WSF_TABLE** parameter with name **tab** and value `{ "1": "ewf", "2": "demo"}`
- `tab[foo]=foo&tab[foo]=bar` : will create a **WSF_TABLE** parameter with name **tab** and value `{ "foo": "bar"}` **WARNING: only the last `tab[foo]` is kept**.

Those rules are applied to query, post, path, .... parameters.

## How to get the input data   (i.e entity-body) ?
See `{WSF_REQUEST}.read_input_data_into (buf: STRING)`

## How to get the raw header data   (i.e the http header text) ?
See `{WSF_REQUEST}.raw_header_data: detachable READABLE_STRING_32`
