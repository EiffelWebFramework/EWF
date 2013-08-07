# Implementing WSF_PREVIOUS_POLICY

This class provides routines which enable the programmer to encode knowledge about resources that have moved (either temporarily, or permanently), or have been permanently removed. There are four routines, but only one is actually deferred.

## resource_previously_existed

By default, this routine says that currently doesn't exist, never has existed. You need to redefine this routine to return True for any URIs that you want to indicate used to exist, and either no longer do so, or have moved to another location.

## resource_moved_permanently

If you have indicated that a resource previously existed, then it may have moved permanently, temporarily, or just ceased to exist. In the first case, you need to redefine this routine to return True for such a resource.
## resource_moved_temporarily

If you have indicated that a resource previously existed, then it may have moved permanently, temporarily, or just ceased to exist. In the second case, you need to redefine this routine to return True for such a resource.

## previous_location

You need to implement this routine. It should provide the locations where a resource has moved to. There must be at least one such location. If more than one is provided, then the first one is considered primary.

If the preconditions for this routine are never met (as is the case by default), then just return an empty list.