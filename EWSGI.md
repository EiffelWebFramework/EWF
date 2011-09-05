- See proposed specifications: [[EWSGI specification| EWSGI-specification]]
- See [[Open questions| EWSGI-open-questions]]
- And below the various proposals and associated decision

----
# Waiting for decision

## Return type of `parameter' (and similar query_, form_data_ ...) should be deferred WGI_VALUE
- Code: **P-2011-09-05-WGI_VALUE**
- Status: proposed on 2011-09-05.
- **WAITING FOR APPROVAL**

> Instead of returning just `READABLE_STRING_32` , it would be better to use **WGI_VALUE** .  
> Mainly to address the multiple value for the same param name, but also for uploaded files.  
> This allows to have various types such as WGI_STRING_VALUE, WGI_LIST_VALUE, WGI_TABLE_VALUE, WGI_FILE_VALUE .  
>   
> Thus we would have: <code>parameter (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE </code>  

## Include the parameter's name in WGI_VALUE interface
- Code: **P-2011-09-05-WGI_VALUE_interface**
- Dependence: adoption of P-2011-09-05-WGI_VALUE , may impact on P-2011-09-05-parameters_ITERABLE
- Status: proposed on 2011-09-05 **WAITING FOR APPROVAL**

> include the corresponding parameter's name in WGI_VALUE interface.  
> Such as `{WGI_VALUE}.name: READABLE_STRING_GENERAL`  (or READABLE_STRING_32).   
>  
> This would also allow to replace  
> signature `parameters: ITERABLE [TUPLE [name: READABLE_STRING_GENERAL; value: WGI__VALUE]]'  
> by a nicer signature  `parameters: ITERABLE [WGI__VALUE]`

## Signature of parameters (and similar) using ITERABLE [...]
- Code: **P-2011-09-05-parameters_ITERABLE**
- Status: proposed on 2011-09-05 **WAITING FOR APPROVAL**

> Description: Instead of forcing the implementation to use HASH_TABLE, DS_HASH_TABLE, DS_HASH_SET, ... or similar 
> we should use `ITERABLE`
> 
> `parameters: ITERABLE [TUPLE [name: READABLE_STRING_GENERAL; value: WGI_VALUE]]`   
>  
>  Or, if `P-2011-09-05-WGI_VALUE_interface` is adopted  (WGI_VALUE.name holds the related parameter's name)  
>  
> `parameters: ITERABLE [WGI_VALUE]`  

----
# Adopted entries

## Change prefix from EWSGI_ to WGI_ 
- Code: **P-2011-08-29-WGI_prefix**
- Status: **adopted**
- Decision: **WGI_**

> shorter and pronouncable prefix for EWSGI class names

----
# Rejected entries

...
