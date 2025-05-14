if exist db.sqlite3 del db.sqlite3
python manage.py makemigrations usuarios empresas tarifarios
python manage.py migrate
python poblar_base_datos.py