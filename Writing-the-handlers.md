# Writing the handlers

Now you have to implement each handler. You need to inherit from WSF_SKELETON_HANDLER (as ORDER_HANDLER does). This involves implementing a lot of deferred routines. There are other routines for which default implementations are provided, which you might want to override. This applies to both routines defined in this class, and those declared in the three policy classes from which it inherits.

## Implementing the routines declared directly in WSF_SKELETON_HANDLER

TODO

## Implementing the policies

* [WSF_OPTIONS_POLICY](./WSF_OPTIONS_POLICY)
* WSF_PREVIOUS_POLICY
* WSF_CACHING_POLICY

TODO