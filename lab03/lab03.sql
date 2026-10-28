select geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city
from geolocation g
where geolocation_state = 'RJ' and geolocation_lng < -46.64 and geolocation_lat < -23.54;

select geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city
from (select * from geolocation g where geolocation_state = 'RJ')
where geolocation_lng < -46.64 and geolocation_lat < -23.54;
