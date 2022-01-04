do $$
DECLARE brand_code varchar(20) := 'HKJP';
begin
  update  dbo.brands set licensee_id = (select id from dbo.licensees where code = brand_code)
  where code = brand_code;
end $$;

do $$
DECLARE brand_code varchar(20) := '21gen';
begin
  update  dbo.brands set licensee_id = (select id from dbo.licensees where code = brand_code)
  where code = brand_code;
end $$;

do $$
DECLARE brand_code varchar(20) := 'WLG';
begin
  update  dbo.brands set licensee_id = (select id from dbo.licensees where code = brand_code)
  where code = brand_code;
end $$;

