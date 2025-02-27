set nocount on;

truncate table dbo.AccChargeCreditorOverride;

declare @exprimentTimes int = 10;
declare @sumQueries int = 100;

declare @tableSize int = 1000;
set @tableSize = 10000;
set @tableSize = 100000;
-- set @tableSize = 1000000;
-- set @tableSize = 10000000;

print 'Table size: ' + convert(varchar(20), @tableSize);
print 'Sum queries: ' + convert(varchar(20), @sumQueries);
print 'Expriment times: ' + convert(varchar(20), @exprimentTimes);

if exists (select * from sys.indexes where name = 'FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm' and object_id = object_id('dbo.AccChargeCreditorOverride'))
begin
    drop index [FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm] on dbo.AccChargeCreditorOverride;
end

create clustered index [FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm]
on dbo.AccChargeCreditorOverride (ACC_AC_ChargeCode, ACC_JobType, ACC_Direction, ACC_TransportMode, ACC_DefaultingRule, ACC_GE_Department, ACC_PaymentTerm);

declare @i int = 0;
while @i < @tableSize
begin
    insert into [dbo].[AccChargeCreditorOverride] (
        [ACC_PK],
        [ACC_AC_ChargeCode],
        [ACC_JobType],
        [ACC_Direction],
        [ACC_TransportMode],
        [ACC_DefaultingRule],
        [ACC_GE_Department],
        [ACC_OH_Creditor],
        [ACC_CreditorRole],
        [ACC_PaymentTerm],
        [ACC_SystemCreateTimeUtc],
        [ACC_SystemCreateUser],
        [ACC_SystemLastEditTimeUtc],
        [ACC_SystemLastEditUser]
    )
    values (
        newid(),
        newid(),
        left(newid(), 3),
        left(newid(), 3),
        left(newid(), 3),
        'SCA',
        case when @i % 2 = 0 then newid() else null end,
        case when @i % 3 = 0 then newid() else null end,
        left(newid(), 3),
        left(newid(), 3),
        dateadd(day, -abs(checksum(newid())) % 365, getutcdate()),
        left(newid(), 3),
        dateadd(day, -abs(checksum(newid())) % 365, getutcdate()),
        left(newid(), 3)
    );

    set @i = @i + 1;
end;

declare @j int = 1;
declare @totalQueryTime int = 0;
declare @startTime datetime, @endTime datetime;
declare @chargeCode varchar(50);

while @j <= @exprimentTimes
begin
    dbcc freeproccache with no_infomsgs;
    dbcc dropcleanbuffers with no_infomsgs;

    select top 1 @chargeCode = ACC_AC_ChargeCode 
    from dbo.AccChargeCreditorOverride 
    order by newid();

    set @startTime = getdate();
    declare @k int = 1;
    while @k <= @sumQueries
    begin
        select ACC_JobType, ACC_OH_Creditor 
        from dbo.AccChargeCreditorOverride
        where ACC_AC_ChargeCode = @chargeCode;
        set @k = @k + 1;
    end;
    set @endTime = getdate();

    set @totalQueryTime = @totalQueryTime + datediff(millisecond, @startTime, @endTime);
    set @j = @j + 1;
end;

print 'Average query costs (clustered indexes): ' + convert(varchar(20), @totalQueryTime / @exprimentTimes) + 'ms';

set @i = 1;
declare @totalRebuildTime int = 0;

while @i <= @exprimentTimes
begin
    insert into [dbo].[AccChargeCreditorOverride] (
        [ACC_PK],
        [ACC_AC_ChargeCode],
        [ACC_JobType],
        [ACC_Direction],
        [ACC_TransportMode],
        [ACC_DefaultingRule],
        [ACC_GE_Department],
        [ACC_OH_Creditor],
        [ACC_CreditorRole],
        [ACC_PaymentTerm],
        [ACC_SystemCreateTimeUtc],
        [ACC_SystemCreateUser],
        [ACC_SystemLastEditTimeUtc],
        [ACC_SystemLastEditUser]
    )
    values (
        newid(),
        newid(),
        left(newid(), 3),
        left(newid(), 3),
        left(newid(), 3),
        'SCA',
        case when @i % 2 = 0 then newid() else null end,
        case when @i % 3 = 0 then newid() else null end,
        left(newid(), 3),
        left(newid(), 3),
        dateadd(day, -abs(checksum(newid())) % 365, getutcdate()),
        left(newid(), 3),
        dateadd(day, -abs(checksum(newid())) % 365, getutcdate()),
        left(newid(), 3)
    );

    set @startTime = getdate();
    alter index all on dbo.AccChargeCreditorOverride rebuild;
    set @endTime = getdate();

    set @totalRebuildTime = @totalRebuildTime + datediff(millisecond, @startTime, @endTime);
    set @i = @i + 1;
end;

print 'Average index rebuild costs (clustered indexes): ' + convert(varchar(20), @totalRebuildTime / @exprimentTimes) + 'ms';

truncate table dbo.AccChargeCreditorOverride;

if exists (select * from sys.indexes where name = 'FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm' and object_id = object_id('dbo.AccChargeCreditorOverride'))
begin
    drop index [FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm] on dbo.AccChargeCreditorOverride;
end

create nonclustered index [FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm]
on dbo.AccChargeCreditorOverride (ACC_AC_ChargeCode, ACC_JobType, ACC_Direction, ACC_TransportMode, ACC_DefaultingRule, ACC_GE_Department, ACC_PaymentTerm);

set @j = 1;
set @totalQueryTime = 0;

while @j <= @exprimentTimes
begin
    dbcc freeproccache with no_infomsgs;
    dbcc dropcleanbuffers with no_infomsgs;
    
    select top 1 @chargeCode = ACC_AC_ChargeCode 
    from dbo.AccChargeCreditorOverride 
    order by newid();

    set @startTime = getdate();
    set @k = 1;
    while @k <= @sumQueries
    begin
        select ACC_JobType, ACC_OH_Creditor 
        from dbo.AccChargeCreditorOverride
        where ACC_AC_ChargeCode = @chargeCode;
        set @k = @k + 1;
    end;
    set @endTime = getdate();

    set @totalQueryTime = @totalQueryTime + datediff(millisecond, @startTime, @endTime);
    set @j = @j + 1;
end;

print 'Average query costs (non-clustered indexes): ' + convert(varchar(20), @totalQueryTime / @exprimentTimes) + 'ms';

set @i = 1;
set @totalRebuildTime = 0;

while @i <= @exprimentTimes
begin
    insert into [dbo].[AccChargeCreditorOverride] (
        [ACC_PK],
        [ACC_AC_ChargeCode],
        [ACC_JobType],
        [ACC_Direction],
        [ACC_TransportMode],
        [ACC_DefaultingRule],
        [ACC_GE_Department],
        [ACC_OH_Creditor],
        [ACC_CreditorRole],
        [ACC_PaymentTerm],
        [ACC_SystemCreateTimeUtc],
        [ACC_SystemCreateUser],
        [ACC_SystemLastEditTimeUtc],
        [ACC_SystemLastEditUser]
    )
    values (
        newid(),
        newid(),
        left(newid(), 3),
        left(newid(), 3),
        left(newid(), 3),
        'SCA',
        case when @i % 2 = 0 then newid() else null end,
        case when @i % 3 = 0 then newid() else null end,
        left(newid(), 3),
        left(newid(), 3),
        dateadd(day, -abs(checksum(newid())) % 365, getutcdate()),
        left(newid(), 3),
        dateadd(day, -abs(checksum(newid())) % 365, getutcdate()),
        left(newid(), 3)
    );
    
    set @startTime = getdate();
    alter index all on dbo.AccChargeCreditorOverride rebuild;
    set @endTime = getdate();

    set @totalRebuildTime = @totalRebuildTime + datediff(millisecond, @startTime, @endTime);
    set @i = @i + 1;
end;

print 'Average index rebuild costs (non-clustered indexes): ' + convert(varchar(20), @totalRebuildTime / @exprimentTimes) + 'ms';