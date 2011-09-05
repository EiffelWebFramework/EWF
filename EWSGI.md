- See proposed specifications: [[EWSGI specification| EWSGI-specification]]
- See [[Open questions| EWSGI-open-questions]]
- And below the various calls for decisions, and effective decisions


### return type of parameter (and similar) should be deferred WGI_VALUE
* Description: Instead of returning READABLE_STRING_32 , it would be better to use **WGI_VALUE** .
 This allows to have various types such as WGI_STRING_VALUE, WGI_LIST_VALUE, WGI_TABLE_VALUE, WGI_FILE_VALUE .

* Status: proposed on 2011-09-05.
* **WAITING FOR APPROVAL**

### <strike>change prefix from EWSGI_ to WGI_ </strike>
* Description: shorter and pronouncable prefix
* Status: **adopted**
* Decision: **WGI_**
