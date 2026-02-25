ALTER TABLE dbo.exchange_email REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = PAGE);
GO


ALTER INDEX [PK__exchange__3213E83F8EC34343] ON [dbo].[exchange_email]
REBUILD WITH (
      DATA_COMPRESSION = PAGE
    , ONLINE = OFF
    , SORT_IN_TEMPDB = OFF
    , MAXDOP = 4
    );

	
ALTER INDEX UK_8guqw3v23js9mghp8v2kkp596 ON [dbo].[exchange_email]
REBUILD WITH (
      DATA_COMPRESSION = PAGE
    , ONLINE = ON
    , SORT_IN_TEMPDB = OFF
    , MAXDOP = 4
    );

	
EXEC sp_estimate_data_compression_savings
@schema_name = 'dbo',
@object_name = 'exchange_email',
@index_id = NULL,
@partition_number = NULL,
@data_compression = 'PAGE';