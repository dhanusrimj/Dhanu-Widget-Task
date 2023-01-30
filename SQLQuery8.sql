create table Bank_Customer_Details( customer_id varchar(50) not null ,Account_Number bigint,customer_name varchar(50),Account_opening_date DATE ,Account_type varchar(50), Branch_ID VARCHAR(50),Account_status varchar(50),Customer_mob_no bigint,Customer_Email varchar(50),Credit_card_number bigint ,PRIMARY KEY (Account_Number))

drop procedure sp_Bank_Customer_Details_insert
drop table Bank_Customer_Details
 

create PROCEDURE sp_Bank_Customer_insert_Details
@json NVARCHAR(max)
AS
BEGIN
   DECLARE @abc NVARCHAR(max) 
 DECLARE @Account_Number NVARCHAR(max)=''
set @Account_Number= (select Account_Number from openjson(@json) with(Account_Number bigint  ));

 INSERT INTO Bank_Customer_Details([customer_id],[Account_Number],[customer_name],[Account_opening_date],[Account_type],[Branch_ID],[Account_status],[Customer_mob_no],[Customer_Email],[Credit_card_number])
        SELECT*FROM OPENJSON(@json)
    WITH ( customer_id varchar(50) '$.customer_id',
    Account_Number varchar(50) '$.Account_Number',
    customer_name varchar(50) '$.customer_name',
    Account_opening_date Date '$.Account_opening_date',
    Account_type varchar(50) '$.Account_type',
	Branch_ID varchar(50) '$.Branch_ID',
	Account_status varchar(50) '$.Account_status',
	Customer_mob_no bigint '$.Customer_mob_no',
	Customer_Email varchar(50) '$.Customer_Email',
	Credit_card_number bigint '$.Credit_card_number'
) 
set @abc=(select(select * from Bank_Customer_Details for Json auto));
set @abc= N'{
        "Account_Number":" @Account_Number "
        "status":"Success",
        "result":"' + @abc + '"
    }'
    SELECT @abc AS responseJson

END
exec sp_Bank_Customer_insert_Details @json='{"customer_id"      :"1228",
                                        "Account_Number"        :"1112", 
                                        "customer_name"          :"ghgg",
                                        "Account_opening_date"  :"2022/12/07",
                                        "Account_type"  :"current",
										"Branch_ID" :"123",
										"Account_status"  :  "open for deposit",
										"Customer_mob_no":"9442176543",
										"Customer_Email"  :  "gjjh@gmail.com",
										"Credit_card_number"  :  "1237"}'

alter PROCEDURE sp_Bank_Customer_select_details
@json NVARCHAR(max)
AS
DECLARE  @abc NVARCHAR(max) 
DECLARE @Account_Number NVARCHAR(max)
set @Account_Number= (select Account_Number from openjson(@json) with(Account_Number bigint '$.Account_Number'));
BEGIN
set @abc=(select(select Bank_Customer_Details.customer_id, Bank_Customer_Details.Account_Number,Bank_Customer_Details.customer_name,Bank_Customer_Details.Account_opening_date,Bank_Customer_Details.Account_type,Bank_Customer_Details.Branch_ID,Bank_Customer_Details.Account_status,Bank_Customer_Details.Customer_mob_no,Bank_Customer_Details.Customer_Email,Bank_Customer_Details.Credit_card_number


FROM Bank_Customer_Details  where Bank_Customer_Details.Account_Number=@Account_Number
for JSON PATH)as jsonvalues)

set @abc= N'{  
  "Account_Number":"' + @Account_Number + '",  
  "status":"Success",    
  "result":' + @abc + '
 }' 
  SELECT ISNULL(@abc,'[]') AS responseJson 

END
exec sp_Bank_Customer_select_details @json='{"Account_Number":"1112"}'


drop procedure sp_Bank_Customer_select_details
drop table Bank_Customer_Details
select * from Bank_Customer_Details
drop procedure sp_Bank_Customer_insert_Details


--------------------------------------------------------------------------------------------------
create table Bank_Customer_disposal_details(Interaction_ID varchar(50) unique,Customer_mob_no bigint,call_start_time time,call_end_time time, Reason varchar(100),date_call DATE)
create PROCEDURE SP_Bank_Customer_call_disposal_details
@json NVARCHAR(max)
AS
BEGIN
   DECLARE @abc NVARCHAR(max) 
 DECLARE @Customer_mob_no NVARCHAR(max)=''
set @Customer_mob_no= (select Customer_mob_no from openjson(@json) with(Customer_mob_no  bigint));

 INSERT INTO Bank_Customer_disposal_details([Interaction_ID],[Customer_mob_no],[call_start_time],[call_end_time],[Reason],[date_call])
        SELECT*FROM OPENJSON(@json)
    WITH ( Interaction_ID varchar(50),
    Customer_mob_no bigint ,
    call_start_time time,
    call_end_time time ,
    Reason varchar(100),
	date_call DATE
) 
set @abc=(select(select * from Bank_Customer_disposal_details for Json auto));
set @abc= N'{
        "Customer_mob_no":"@Customer_mob_no"
        "status":"Success",
        "result":"' + @abc + '"
    }'
    SELECT @abc AS responseJson

END
exec SP_Bank_Customer_call_disposal_details @json='{"Interaction_ID":"1317",
                                        "Customer_mob_no":"9488585413", 
                                        "call_start_time":"04:20:00",
                                        "call_end_time" :"05:30:33",
                                        "Reason" :"Checking Account Balance",
										"date_call":"2021/11/06"}'
SELECT*FROM Bank_Customer_disposal_details
sp_help Bank_Customer_disposal_details
drop table Bank_Customer_disposal_details

select* from Bank_Customer_disposal_details
drop procedure SP_Bank_Customer_call_disposal_details

create PROCEDURE SP_Bank_Customer_call_disposal_select_details
@json NVARCHAR(max)
AS
DECLARE  @abc NVARCHAR(max) 
DECLARE @Customer_mob_no NVARCHAR(max)
set @Customer_mob_no= (select Customer_mob_no from openjson(@json) with(Customer_mob_no bigint '$.Customer_mob_no'));
BEGIN
set @abc=(select(select Bank_Customer_disposal_details.Interaction_ID, Bank_Customer_disposal_details.Customer_mob_no,Bank_Customer_disposal_details.call_start_time,Bank_Customer_disposal_details.call_end_time,Bank_Customer_disposal_details.Reason,Bank_Customer_disposal_details.date_call

FROM Bank_Customer_disposal_details  where Bank_Customer_disposal_details.Customer_mob_no=@Customer_mob_no
for JSON PATH)as jsonvalues)

set @abc= N'{  
  "Customer_mob_no":"' + @Customer_mob_no + '",  
  "status":"Success",    
  "result":' + @abc + '
 }' 
  SELECT ISNULL(@abc,'[]') AS responseJson 

END

exec SP_Bank_Customer_call_disposal_select_details @json='{"Customer_mob_no":"9488585413"}'
drop table Bank_Customer_disposal_details
drop procedure SP_Bank_Customer_call_disposal_select_details