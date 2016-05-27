---
layout: default
title: README
base_url: ../../../
---
- See proposed specifications: [EWSGI specification](EWSGI-specification)
- See [Open questions](EWSGI-Open-Questions)
- And below the various proposals and associated decision

----
# Waiting for decision

## Include EWF_HEADER into EWSGI as WGI_HEADERS
- Code: **P-2011-09-26-include-wgi-headers**
- Status: proposed on 2011-09-26 **WAITING FOR APPROVAL**

> Include WGI_HEADERS to help the user to build HTTP Header. 
> So that he doesn't have to know the HTTP specification for usual needs


----
# Adopted entries

## Rename `parameter` into `item`
- Code: **P-2011-09-07-renaming_REQUEST_item**
- Status: proposed on 2011-09-07 **ADOPTED-by-default**

> rename `{REQUEST}.parameter (n: READABLE_STRING_GENERAL): detachable WGI_VALUE`   
> into `{REQUEST}.item (n: READABLE_STRING_GENERAL): detachable WGI_VALUE`   
> and similar for `parameters` -> `items`

## Return type of `parameter' (and similar query_, form_data_ ...) should be deferred WGI_VALUE
- Code: **P-2011-09-05-WGI_VALUE**
- Status: proposed on 2011-09-05 **ADOPTED-by-default**

> Instead of returning just `READABLE_STRING_32` , it would be better to use **WGI_VALUE** .  
> Mainly to address the multiple value for the same param name, but also for uploaded files.  
> This allows to have various types such as WGI_STRING_VALUE, WGI_LIST_VALUE, WGI_TABLE_VALUE, WGI_FILE_VALUE .  
>   
> Thus we would have: <code>parameter (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE </code>  

## Include the parameter's name in WGI_VALUE interface
- Code: **P-2011-09-05-WGI_VALUE_interface**
- Dependence: adoption of P-2011-09-05-WGI_VALUE , may impact on P-2011-09-05-parameters_ITERABLE
- Status: proposed on 2011-09-05 **ADOPTED-by-default**

> include the corresponding parameter's name in WGI_VALUE interface.  
> Such as `{WGI_VALUE}.name: READABLE_STRING_GENERAL`  (or READABLE_STRING_32).   
>  
> This would also allow to replace  
> signature `parameters: ITERABLE [TUPLE [name: READABLE_STRING_GENERAL; value: WGI__VALUE]]'  
> by a nicer signature  `parameters: ITERABLE [WGI__VALUE]`

## Signature of parameters (and similar) using ITERABLE [...]
- Code: **P-2011-09-05-parameters_ITERABLE**
- Status: proposed on 2011-09-05 **ADOPTED-by-default**

> Description: Instead of forcing the implementation to use HASH_TABLE, DS_HASH_TABLE, DS_HASH_SET, ... or similar 
> we should use `ITERABLE`
> 
> `parameters: ITERABLE [TUPLE [name: READABLE_STRING_GENERAL; value: WGI_VALUE]]`   
>  
>  Or, if `P-2011-09-05-WGI_VALUE_interface` is adopted  (WGI_VALUE.name holds the related parameter's name)  
>  
> `parameters: ITERABLE [WGI_VALUE]`  

## Change prefix from EWSGI_ to WGI_ 
- Code: **P-2011-08-29-WGI_prefix**
- Status: **adopted**
- Decision: **WGI_**

> shorter and pronouncable prefix for EWSGI class names

----
# Rejected entries

...
