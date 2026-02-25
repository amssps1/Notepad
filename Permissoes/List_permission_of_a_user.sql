
-- verificar permissões de um user

EXECUTE AS USER = 'user'
SELECT 
    permission_name 
FROM fn_my_permissions(null, 'DATABASE')
ORDER BY subentity_name, permission_name
REVERT;
