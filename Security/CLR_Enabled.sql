
/* Disable CLR   **/

-- 1. Enable Advanced Options
exec sp_configure 'show advanced options', 1;
reconfigure with override;

-- 2. Disable CLR
exec sp_configure 'clr enabled',0;
reconfigure with override;

-- 3. Disable Advanced Options
exec sp_configure 'show advanced options', 1;
reconfigure with override;


/* END Disable CLR  */

---------------------------------------  

/* Enable CLR   **/
-- 1. Enable Advanced Options
exec sp_configure 'show advanced options', 1;
reconfigure with override;

-- 2. Enable CLR
exec sp_configure 'clr enabled',1;
reconfigure with override;

-- 3. Disable Advanced Options
exec sp_configure 'show advanced options', 1;
reconfigure with override;