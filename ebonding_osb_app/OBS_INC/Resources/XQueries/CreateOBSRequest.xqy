xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://eai/Sav/Trillium/Types";
(:: import schema at "../WSDL/PH_B2B_EPH_TRILLIUM_TroubleTicket_source_services.wsdl" ::)
declare namespace ns2="http://www.sita.aero/schema/IncidentEbondingMessageV1";
(:: import schema at "../../../Common/Resources/Schemas/IncidentEbondingMessage.xsd" ::)

declare variable $CanonicalRequestMessage as element() (:: schema-element(ns2:IncidentRequestMessage) ::) external;

declare function local:func($CanonicalRequestMessage as element() (:: schema-element(ns2:IncidentRequestMessage) ::)) as element() (:: schema-element(ns1:TRANSACTION) ::) {
    <ns1:TRANSACTION>
      
        {if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
          <TRANSACTION_TYPE>Creation</TRANSACTION_TYPE>
        else if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='UPDATE')then
          <TRANSACTION_TYPE>Update</TRANSACTION_TYPE>
        else if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='UPDATE_REFNUMBER')then
          <TRANSACTION_TYPE>Ack</TRANSACTION_TYPE>
        else()
        }
        {
        if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
          <REC_TYPE>Incident</REC_TYPE>
        else(<ID>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionId)}</ID>)
        }
        <SR_ID>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:TicketNumber)}</SR_ID>
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)!='CREATE')then
              <EXTERNAL_ID>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Supplier/ns2:RefNumber)}</EXTERNAL_ID>
            else ()
        }
        <INTERFACE>SITA</INTERFACE>
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
            <DESCRIPTION>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Description)}</DESCRIPTION>
          else()
        }
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
            <SUMMARY>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ShortDescription)}</SUMMARY>
          else()
        }
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
            <SEVERITY>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Priority)}</SEVERITY>
          else()
        }
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE' or fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='UPDATE')then
            <STATUS>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Status)}</STATUS>
          else()
        }
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
            <CATEGORY>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Category)}</CATEGORY>
          else()
        }
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
            <GROUP>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:AssignmentGroup)}</GROUP>
          else()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <LOCATION>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentLocation/ns2:Location)}</LOCATION>
            else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <CUSTOMER>
                  <LAST_NAME>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentContact/ns2:LastName)}</LAST_NAME>
                  <FIRST_NAME>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentContact/ns2:FirstName)}</FIRST_NAME>
                  <MIDDLE_NAME>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentContact/ns2:MiddleName)}</MIDDLE_NAME>
                  <EMAIL_ADDRESS>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentContact/ns2:EmailAddress)}</EMAIL_ADDRESS>
              </CUSTOMER>
              
            else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <PRIMARY_CI>
                      <ASSET_TAG>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentAsset/ns2:BusinessService)}</ASSET_TAG>
              </PRIMARY_CI>
            else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <SECONDARY_CI>
                <ASSET_TAG>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentAsset/ns2:CI)}</ASSET_TAG>
              </SECONDARY_CI>
            else ()
        }
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='UPDATE')then
            <UPDATE_INFO>
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:AssignmentGroup/text())>0)then
                    
                    <UPDATE_FIELD>
                      <FIELD_NAME>GROUP</FIELD_NAME>
                      <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:AssignmentGroup)}</FIELD_VALUE>
                    </UPDATE_FIELD>
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentContact/ns2:EmailAddress/text())>0)then
                    <UPDATE_FIELD>
                      <FIELD_NAME>AFFECTED_CONTACT</FIELD_NAME>
                      <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentContact/ns2:EmailAddress)}</FIELD_VALUE>
                    </UPDATE_FIELD>
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ETA/text())>0)then
                    <UPDATE_FIELD>
                      <FIELD_NAME>ETA</FIELD_NAME>
                      <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ETA)}</FIELD_VALUE>
                    </UPDATE_FIELD>
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Status/text())>0)then
                    <UPDATE_FIELD>
                      <FIELD_NAME>STATUS</FIELD_NAME>
                      <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Status)}</FIELD_VALUE>
                      
                    </UPDATE_FIELD>
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:AFT/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>ATD</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:AFT)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Priority/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>SEVERITY</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Priority)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Category/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>CATEGORY</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Category)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:AdditionalComments/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>COMMENTS</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:AdditionalComments)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ShortDescription/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>SUMMARY</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ShortDescription)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Description/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>DESCRIPTION</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Description)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ATA/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>ATA</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ATA)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:TravelTime/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>TRAVEL_TIME</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:TravelTime)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Impact/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>IMPACT</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Impact)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentLocation/ns2:Issue/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>SYMPTOM</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentLocation/ns2:Issue)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:TimeSpent/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>TIME_ON_SITE</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:TimeSpent)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentAsset/ns2:BusinessService/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>SERVICE_CI</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentAsset/ns2:BusinessService)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Urgency/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>URGENCY</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Urgency)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    else()
                }
                {
                  if(fn:string-length($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ResolutionCode/text())>0)then
                    <UPDATE_FIELD>
                        <FIELD_NAME>RESOLUTION_CODE</FIELD_NAME>
                        <FIELD_VALUE>{data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ResolutionCode)}</FIELD_VALUE>
                        
                    </UPDATE_FIELD>
                    else()
                }
            </UPDATE_INFO>
          else()
        }
        {
          if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='UPDATE')then
            <ACT_LOG>
                 <LOG_DESCRIPTION>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:SupplierComments)}</LOG_DESCRIPTION>
            </ACT_LOG>
          else()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <NCC>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentAsset/ns2:NCC)}</NCC>
            else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <IMPACT>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Impact)}</IMPACT>
            else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
                <URGENCY>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:Urgency)}</URGENCY>
              else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <ID>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionId)}</ID>
          else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <REPORT_METHOD>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:ReportMethod)}</REPORT_METHOD>
            else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <CUSTOMER_LOC>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentLocation/ns2:CustomerLOCCode)}</CUSTOMER_LOC>
            else ()
        }
        
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <OPEN_DATE>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentDetails/ns2:OpenDate)}</OPEN_DATE>
            else ()
        }
        {
            if(fn:data($CanonicalRequestMessage/ns2:IncidentRequestHeader/ns2:TransactionType)='CREATE')then
              <SYMPTOM>{fn:data($CanonicalRequestMessage/ns2:IncidentRequestBody/ns2:IncidentLocation/ns2:Issue)}</SYMPTOM>
            else ()
        }
        
        
    </ns1:TRANSACTION>
};

local:func($CanonicalRequestMessage)