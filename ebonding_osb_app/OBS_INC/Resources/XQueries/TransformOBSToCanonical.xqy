xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare default element namespace "";
(:: import schema at "../Schemas/OBS_INC_ClarifySchema.xsd" ::)
declare namespace ns1="http://www.sita.aero/schema/IncidentEbondingMessageV1";
(:: import schema at "../../../Common/Resources/Schemas/IncidentEbondingMessage.xsd" ::)

declare variable $OBSClarifyInboundMessage as element() (:: schema-element(TRANSACTION) ::) external;
declare variable $TransactionType as xs:string external;
declare variable $Message_TranId as xs:string external;
declare variable $TicketNumber as xs:string external;
declare variable $DefaultValues as element(*) external;
declare variable $ResolvedValues as element(*) external;

declare function local:func($OBSClarifyInboundMessage as element() (:: schema-element(TRANSACTION) ::),
                            $TransactionType as xs:string,
                            $Message_TranId as xs:string,
                            $TicketNumber as xs:string,
                            $ResolvedValues as element(*),
                            $DefaultValues as element(*)) as element()  (:: schema-element(ns1:IncidentRequestMessage) ::) {
    <ns1:IncidentRequestMessage>
        <ns1:IncidentRequestHeader>
              <ns1:TransactionId>{$Message_TranId}</ns1:TransactionId>
              <ns1:TransactionType>{$TransactionType}</ns1:TransactionType>
              <ns1:RecType>INC</ns1:RecType>
              <ns1:SourceSystem>OBS</ns1:SourceSystem>
              <ns1:DestinationSystem>SN</ns1:DestinationSystem>
        </ns1:IncidentRequestHeader>
        <ns1:IncidentRequestBody>
              <ns1:IncidentDetails>
                    {
                    if($TransactionType='CREATE')
                      then()
                    else(<ns1:TicketNumber>{$TicketNumber}</ns1:TicketNumber>)
                    }
                    <ns1:Status>{fn:data($ResolvedValues/Status)}</ns1:Status>
                   {
                    if((data($OBSClarifyInboundMessage/REPORT_METHOD) = 'Proactive') and (data($OBSClarifyInboundMessage/CATEGORY) = '1'))
                      then( <ns1:AssignmentGroup>{fn:data($DefaultValues/PRO_ACT_DEF_GROUP)}</ns1:AssignmentGroup>)
                    else if((data($OBSClarifyInboundMessage/REPORT_METHOD) = 'Reactive') and (data($OBSClarifyInboundMessage/CATEGORY) = '1'))
                      then ( <ns1:AssignmentGroup>{fn:data($DefaultValues/DEF_GROUP)}</ns1:AssignmentGroup>)
                    else if((data($OBSClarifyInboundMessage/REPORT_METHOD) = 'Reactive') and (data($OBSClarifyInboundMessage/CATEGORY) = '10' or (data($OBSClarifyInboundMessage/CATEGORY) = '20')))
                      then ( <ns1:AssignmentGroup>{fn:data($DefaultValues/DEF_GROUP)}</ns1:AssignmentGroup>)
                    else if(fn:data($ResolvedValues/LocGroup)!='' and (data($OBSClarifyInboundMessage/REPORT_METHOD) = 'Proactive' or (data($OBSClarifyInboundMessage/REPORT_METHOD)='Reactive') and (data($OBSClarifyInboundMessage/CATEGORY) = '2' or data($OBSClarifyInboundMessage/CATEGORY)='3')))
                      then (<ns1:AssignmentGroup>{fn:data($ResolvedValues/LocGroup)}</ns1:AssignmentGroup>)
                    else(<ns1:AssignmentGroup>{fn:data($DefaultValues/DEF_GROUP)}</ns1:AssignmentGroup>)
                    }
                    
                    {
                    if(((data($OBSClarifyInboundMessage/REPORT_METHOD) eq 'Proactive' or 'Reactive') and (data($OBSClarifyInboundMessage/CATEGORY eq '2' or '3'))))
                    then( <ns1:SDOwnerGroup>{fn:data($DefaultValues/zservicedesk_group)}</ns1:SDOwnerGroup>)
                    else(<ns1:SDOwnerGroup></ns1:SDOwnerGroup>)
                    }
                    
                    <ns1:ShortDescription>{fn:data($OBSClarifyInboundMessage/SUMMARY)}</ns1:ShortDescription>
                    <ns1:Priority>{
                      if(fn:exists($ResolvedValues/Priority/text()))
                      then($ResolvedValues/Priority/text())
                      else($DefaultValues/SEVERITY/text())
                    }</ns1:Priority>
                    <ns1:Category>{
                      if(fn:exists($ResolvedValues/Category/text()))
                      then($ResolvedValues/Category/text())
                      else($DefaultValues/CATEGORY/text())
                    }</ns1:Category>
                    <ns1:SubCategory>{$ResolvedValues/SubCategory/text()}</ns1:SubCategory>
                    <ns1:Impact>{data($ResolvedValues/Impact)}</ns1:Impact>
                    <ns1:Urgency>{data($ResolvedValues/Urgency)}</ns1:Urgency>
                    <ns1:Customer>
                          <ns1:Name>OBS</ns1:Name>
                          <ns1:RefNumber>{data($OBSClarifyInboundMessage/EXTERNAL_ID)}</ns1:RefNumber>
                    </ns1:Customer>
                    <ns1:ETA>{$OBSClarifyInboundMessage/UPDATE_INFO/UPDATE_FIELD[FIELD_NAME/text()='eta']/FIELD_VALUE/text()}</ns1:ETA>
                    <ns1:ATA>{$OBSClarifyInboundMessage/UPDATE_INFO/UPDATE_FIELD[FIELD_NAME/text()='ata']/FIELD_VALUE/text()}</ns1:ATA>
                    {
                      if($OBSClarifyInboundMessage/UPDATE_INFO/UPDATE_FIELD[FIELD_NAME/text()='sfu_code']/FIELD_VALUE/text()='200')then
                        <ns1:AdditionalComments>{concat('ErrorCode: ',$OBSClarifyInboundMessage/UPDATE_INFO/UPDATE_FIELD[FIELD_NAME/text()='sfu_code']/FIELD_VALUE/text(),' ErrorDescription: ',$OBSClarifyInboundMessage/UPDATE_INFO/UPDATE_FIELD[FIELD_NAME/text()='sfu_label']/FIELD_VALUE/text())}</ns1:AdditionalComments>
                      else(<ns1:AdditionalComments>{data($OBSClarifyInboundMessage/ACT_LOG/DESCRIPTION)}</ns1:AdditionalComments>)
                    }
                    <ns1:ResolutionCode>{$OBSClarifyInboundMessage/UPDATE_INFO/UPDATE_FIELD[FIELD_NAME/text()='resol_local']/FIELD_VALUE/text()}</ns1:ResolutionCode>
                    <ns1:OpenDate>{$OBSClarifyInboundMessage/TIME_STAMP}</ns1:OpenDate>
                    <ns1:ReportMethod>{fn:data($OBSClarifyInboundMessage/REPORT_METHOD)}</ns1:ReportMethod>
              </ns1:IncidentDetails>
              <ns1:IncidentAsset>
                    <ns1:CI>{data($OBSClarifyInboundMessage/SECONDARY_CI/ASSET_TAG)}</ns1:CI>
                   <ns1:BusinessService>{fn:data($OBSClarifyInboundMessage/PRIMARY_CI/ASSET_TAG)}</ns1:BusinessService>
                 </ns1:IncidentAsset>
               <ns1:IncidentLocation>
                 <ns1:Location>{fn:data($OBSClarifyInboundMessage/LOCATION)}</ns1:Location>
              </ns1:IncidentLocation>
        </ns1:IncidentRequestBody>
    </ns1:IncidentRequestMessage>
};

local:func($OBSClarifyInboundMessage, $TransactionType, $Message_TranId, $TicketNumber, $ResolvedValues, $DefaultValues)