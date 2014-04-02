See WSF_REQUEST

Note that by default there is a smart computation for the query/post/... parameters:
for instance
- `?q=a&q=b` :  will create a WSF_MULTIPLE_STRING parameter with name **q** and value `[a,b]`
- `?tab[a]=ewf&tab[b]=demo` : will create a WSF_TABLE parameter with name **tab** and value `{ "a": "ewf", "b": "demo"}`
- `?tab[]=ewf&tab[]=demo` : will create a WSF_TABLE parameter with name **tab** and value `{ "1": "ewf", "2": "demo"}`
- `?tab[foo]=foo&tab[foo]=bar` : will create a WSF_TABLE parameter with name **tab** and value `{ "foo": "bar"}` **WARNING: only the last `tab[foo]` is kept**.

Those rules are applied to query, post, path, .... parameters.