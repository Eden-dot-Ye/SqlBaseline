set nocount on;

truncate table dbo.AccChargeCreditorOverride;

declare @tableSize int = 1000000;
-- 10000, 100000

declare @hasModified int = 1;
-- 0, 1

print 'Table size: ' + convert(varchar(20), @tableSize);
print 'Has modified: ' + convert(varchar(20), @hasModified);

if exists (select *
from sys.indexes
where name = 'FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm' and object_id = object_id('dbo.AccChargeCreditorOverride'))
begin
    drop index [FK_UC__ACC_AC_ChargeCode_ACC_JobType_ACC_Direction_ACC_TransportMode_ACC_DefaultingRule_ACC_GE_Department_ACC_PaymentTerm] on dbo.AccChargeCreditorOverride;
end

if exists (select *
from sys.indexes
where name = 'IX_ACC_AC_ChargeCode_Clustered' and object_id = object_id('dbo.AccChargeCreditorOverride'))
begin
    drop index IX_ACC_AC_ChargeCode_Clustered on dbo.AccChargeCreditorOverride;
end

if exists (select *
from sys.indexes
where name = 'IX_ACC_Combined_Clustered' and object_id = object_id('dbo.AccChargeCreditorOverride'))
begin
    drop index IX_ACC_Combined_Clustered on dbo.AccChargeCreditorOverride;
end

if exists (select *
from sys.indexes
where name = 'IX_ACC_Combined_Non_Clustered' and object_id = object_id('dbo.AccChargeCreditorOverride'))
begin
    drop index IX_ACC_Combined_Non_Clustered on dbo.AccChargeCreditorOverride;
end

if @hasModified = 0
begin
    create clustered index IX_ACC_Combined_Clustered on dbo.AccChargeCreditorOverride (
        ACC_AC_ChargeCode,
        ACC_JobType,
        ACC_Direction,
        ACC_TransportMode,
        ACC_DefaultingRule,
        ACC_GE_Department,
        ACC_PaymentTerm
    );
end
else
begin
    create clustered index IX_ACC_AC_ChargeCode_Clustered on dbo.AccChargeCreditorOverride (ACC_AC_ChargeCode);
    create nonclustered index IX_ACC_Combined_Non_Clustered on dbo.AccChargeCreditorOverride (
        ACC_AC_ChargeCode,
        ACC_JobType,
        ACC_Direction,
        ACC_TransportMode,
        ACC_DefaultingRule,
        ACC_GE_Department,
        ACC_PaymentTerm
    );
end

declare @i int = 0;
while @i < @tableSize
begin
    insert into [dbo].[AccChargeCreditorOverride]
        (
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
    values
        (
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