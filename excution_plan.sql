checkpoint;
dbcc freeproccache with no_infomsgs;
dbcc dropcleanbuffers with no_infomsgs;

declare @CWO1_ as uniqueidentifier,
    @CWRanker1 as varchar(3),
    @CWRanker2 as varchar(3),
    @CWRanker3 as varchar(3),
    @CWRanker4 as varchar(3),
    @CWRanker5 as varchar(3),
    @CWRanker6 as varchar(3),
    @CWRanker7 as varchar(3),
    @CWRanker8 as varchar(3),
    @CWRanker9 as varchar(3),
    @CWRanker10 as varchar(3),
    @CWRanker11 as varchar(3),
    @CWRanker12 as uniqueidentifier;

select top 1
    @CWO1_ = ACC_AC_ChargeCode,
    @CWRanker1 = ACC_JobType,
    @CWRanker2 = ACC_JobType,
    @CWRanker3 = ACC_Direction,
    @CWRanker4 = ACC_Direction,
    @CWRanker5 = ACC_Direction,
    @CWRanker6 = ACC_TransportMode,
    @CWRanker7 = ACC_TransportMode,
    @CWRanker8 = ACC_TransportMode,
    @CWRanker9 = ACC_PaymentTerm,
    @CWRanker10 = ACC_PaymentTerm,
    @CWRanker11 = ACC_PaymentTerm,
    @CWRanker12 = ACC_GE_Department
from dbo.AccChargeCreditorOverride
order by newid();

select top 1
    ACC_PK, ACC_AC_ChargeCode, ACC_CreditorRole, ACC_DefaultingRule, ACC_Direction,
    ACC_GE_Department, ACC_JobType, ACC_OH_Creditor, ACC_PaymentTerm, ACC_SystemCreateTimeUtc,
    ACC_SystemCreateUser, ACC_SystemLastEditTimeUtc, ACC_SystemLastEditUser, ACC_TransportMode
from dbo.AccChargeCreditorOverride
where 
    (((ACC_AC_ChargeCode = @CWO1_ and (ACC_JobType = @CWRanker1 or ACC_JobType = @CWRanker2)) 
    and (ACC_Direction = @CWRanker3 or ACC_Direction = @CWRanker4 or ACC_Direction = @CWRanker5)) 
    and (ACC_TransportMode = @CWRanker6 or ACC_TransportMode = @CWRanker7 or ACC_TransportMode = @CWRanker8)) 
    and (ACC_PaymentTerm = @CWRanker9 or ACC_PaymentTerm = @CWRanker10 or ACC_PaymentTerm = @CWRanker11) 
    and (ACC_GE_Department = @CWRanker12 or ACC_GE_Department is null)
order by 
    case when ACC_JobType = @CWRanker1 then 8192 else 0 end + 
    case when ACC_JobType = @CWRanker2 then 4096 else 0 end + 
    case when ACC_Direction = @CWRanker3 then 2048 else 0 end + 
    case when ACC_Direction = @CWRanker4 then 1024 else 0 end + 
    case when ACC_Direction = @CWRanker5 then 512 else 0 end + 
    case when ACC_TransportMode = @CWRanker6 then 256 else 0 end + 
    case when ACC_TransportMode = @CWRanker7 then 128 else 0 end + 
    case when ACC_TransportMode = @CWRanker8 then 64 else 0 end + 
    case when ACC_PaymentTerm = @CWRanker9 then 32 else 0 end + 
    case when ACC_PaymentTerm = @CWRanker10 then 16 else 0 end + 
    case when ACC_PaymentTerm = @CWRanker11 then 8 else 0 end + 
    case when ACC_GE_Department = @CWRanker12 then 4 else 0 end + 
    case when ACC_GE_Department is null then 2 else 0 end desc;