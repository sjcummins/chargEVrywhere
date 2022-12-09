from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
import json
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage

# -------------------------GET FUNCTIONS-------------------------
@csrf_exempt
def getUser(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    user_id = request.GET.get('user_id')

    cursor = connection.cursor()
    cursor.execute('SELECT * FROM users WHERE user_id = ' + str(user_id) + ';')
    rows = cursor.fetchone()

    if( rows == None):
        return JsonResponse({})

    response = {"user_id": rows[0],
          "first_name": rows[1],
           "last_name" : rows[2],
           "year_of_birth" : rows[3],
           "month_of_birth" : rows[4],
           "day_of_birth" : rows[5],
           "username" : rows[6],
           "password" : rows[7],
           "charging_since" : rows[8],
           "description" : rows[9],}

    return JsonResponse(response)

@csrf_exempt
def getUser2(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    user_id = request.GET.get('user_id')

    cursor = connection.cursor()
    cursor.execute('SELECT * FROM users WHERE user_id = ' + str(user_id) + ';')
    rows = cursor.fetchone()

    if( rows == None):
        return JsonResponse({})

    response = {"user_id": rows[0],
          "first_name": rows[1],
           "last_name" : rows[2],
           "year_of_birth" : rows[3],
           "month_of_birth" : rows[4],
           "day_of_birth" : rows[5],
           "username" : rows[6],
           "password" : rows[7],
           "charging_since" : rows[8],
           "description" : rows[9],
           "img_url" : rows[10]}

    return JsonResponse(response)

@csrf_exempt
def getLogin(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    username = request.GET.get('username')
    password = request.GET.get('password')

    cursor = connection.cursor()
    cursor.execute("SELECT * FROM users WHERE username = '" +str(username) + "' and password = '" + str(password) + "';")
    rows = cursor.fetchone()

    if( rows == None):
        return JsonResponse({})

    response = {"user_id": rows[0]}

    return JsonResponse(response)

@csrf_exempt
def getChargerInfo(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    user_id = request.GET.get('user_id')
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM chargers WHERE user_id = ' + str(user_id) + ';')
    rows = cursor.fetchall()

    if( rows == []):
        return JsonResponse({})

    response = {
        "cid": rows[0][0],
        "user_id": rows[0][1],
        "available": rows[0][2],
        "start_time_availability": rows[0][3],
        "end_time_availability": rows[0][4],
        "charger_type": rows[0][5],
        "price": rows[0][6],
        "street_address": rows[0][7],
        "city_address": rows[0][8],
        "state_address": rows[0][9],
        "zipcode_address": rows[0][10],
        "latitude": rows[0][11],
        "longitude": rows[0][12],
            }

    return JsonResponse(response)

@csrf_exempt
def getChargerWindow(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    cid = request.GET.get('cid')
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM chargers WHERE cid = ' + str(cid) + ';')
    rows = cursor.fetchall()

    if( rows == []):
        return JsonResponse({})

    response = {
        "cid": rows[0][0],
        "user_id": rows[0][1],
        "available": rows[0][2],
        "start_time_availability": rows[0][3],
        "end_time_availability": rows[0][4],
        "charger_type": rows[0][5],
        "price": rows[0][6],
        "street_address": rows[0][7],
        "city_address": rows[0][8],
        "state_address": rows[0][9],
        "zipcode_address": rows[0][10],
        "latitude": rows[0][11],
        "longitude": rows[0][12],
            }

    return JsonResponse(response)

@csrf_exempt
def getLocalChargers(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    latitude = request.GET.get('latitude')
    longitude = request.GET.get('longitude')
    radius = request.GET.get('radius')

    cursor = connection.cursor()
    cursor.execute('SELECT cid FROM chargers;')
#    cursor.execute('SELECT c.cid FROM chargers c WHERE 3963 * ACOS((SIN(c.latitude) * SIN(' + str(latitude) + ')) + COS(c.latitude) * COS(' + str(latitude) + ') * COS(' + str(longitude) + ' - c.longitude)) <= ' +str(radius) + ';')
    rows = cursor.fetchall()

    if(rows == []):
        return JsonResponse({})

    response = {
	"cid": rows
        }
    response1 = {'cid': []}
    for row in response['cid']:
        response1['cid'].append(row[0])

    return JsonResponse(response1)

@csrf_exempt
def getAddCharger(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    user_id = request.GET.get('user_id')
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM add_charger WHERE user_id = ' + str(user_id) + ';')
    rows = cursor.fetchall()

    if( rows == []):
        return JsonResponse({})

    response = {
            "user_id": rows[0][0],
            "cid": rows[0][1]
            }
    return JsonResponse(response)

@csrf_exempt
def getReview(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    review_id = request.GET.get('review_id')
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM reviews WHERE review_id = ' + str(review_id) + ';')
    rows = cursor.fetchall()

    if( rows == []):
        return JsonResponse({})
    response = {
       "review_id": rows[0][0],
       "review_date": rows[0][1],
       "stars" : rows[0][2],
       "subject": rows[0][3],
       "message": rows[0][4],
       "receiving_review_type": rows[0][5],
       "host_id": rows[0][6],
       "driver_id": rows[0][7]
            }

    return JsonResponse(response)

@csrf_exempt
def getAverageReview(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    reviewType = request.GET.get('receiving_review_type')
    user_id = request.GET.get('user_id')

    if(reviewType == "HOST"):
        cursor = connection.cursor()
        cursor.execute("SELECT AVG(stars) FROM reviews WHERE host_id = '" + str(user_id) + "';")
        # cursor.execute("SELECT AVG(stars) FROM reviews WHERE host_id = 2;")
        rows = cursor.fetchone()

    if(reviewType == "DRIVER"):
        cursor = connection.cursor()
        cursor.execute("SELECT AVG(stars) FROM reviews WHERE driver_id = " + str(user_id) + ";")
        rows = cursor.fetchone()

    if( rows == None):
        return JsonResponse({})

    response = {"avg_rating": rows[0]}
    return JsonResponse(response)

@csrf_exempt
def getDriverReview(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    driver_id = request.GET.get('driver_id')
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM reviews WHERE driver_id = ' + str(driver_id) + "AND receiving_review_type = 'DRIVER';")
    rows = cursor.fetchall()

    if( rows == []):
        return JsonResponse({})

    response = {"reviews": []}
    for x in rows:
        cursor2 = connection.cursor()
        cursor2.execute('SELECT * FROM users WHERE user_id = ' + str(x[6]) + ';')
        reviewingHost = cursor2.fetchall()
        temp_img_url = reviewingHost[0][10]
        if temp_img_url is None:
            temp_img_url = ""
        response["reviews"].append({
       "first_name": reviewingHost[0][1],
       "last_name": reviewingHost[0][2],
       "review_id": x[0],
       "review_date": x[1],
       "stars" : x[2],
       "subject": x[3],
       "message": x[4],
       "receiving_review_type": x[5],
       "host_id": x[6],
       "driver_id": x[7],
       "img_url": temp_img_url
            })
    return JsonResponse(response)

@csrf_exempt
def getHostReview(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    host_id = request.GET.get('host_id')
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM reviews WHERE host_id = ' + str(host_id) + "AND receiving_review_type = 'HOST';")
    rows = cursor.fetchall()

    if( rows == []):
        return JsonResponse({})
    response = {"reviews": []}
    for x in rows:
        cursor2 = connection.cursor()
        cursor2.execute('SELECT * FROM users WHERE user_id = ' + str(x[7]) + ';')
        reviewingDriver = cursor2.fetchall()
        temp_img_url = reviewingDriver[0][10]
        if temp_img_url is None:
            temp_img_url = ""
        response["reviews"].append({
       "first_name": reviewingDriver[0][1],
       "last_name": reviewingDriver[0][2],
       "review_id": x[0],
       "review_date": x[1],
       "stars" : x[2],
       "subject": x[3],
       "message": x[4],
       "receiving_review_type": x[5],
       "host_id": x[6],
       "driver_id": x[7],
       "img_url": temp_img_url
            })
    return JsonResponse(response)

@csrf_exempt
def getChargerPhotos(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    cid = request.GET.get('cid')
    cursor = connection.cursor()
    cursor.execute('SELECT img_url FROM photos WHERE cid = ' + str(cid) + ';')
    rows = cursor.fetchall()
    if( rows == []):
        return JsonResponse({})
    new_rows = []
    for item in rows:
        new_rows.append(item[0])
    response = {
        "photos": new_rows
        }

    return JsonResponse(response)

@csrf_exempt
def getVehicle(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    user_id = request.GET.get('user_id')
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM vehicle WHERE user_id = '" + str(user_id) + "';")
    rows = cursor.fetchone()
    if(rows == None):
        return JsonResponse({})

    response = {
      "user_id": rows[0],
      "lics_number": rows[1],
      "model": rows[2],
      "color": rows[3]
            }
    return JsonResponse(response)

@csrf_exempt
def getRequest(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    host_id = request.GET.get('host_id')

    cursor = connection.cursor()
    cursor.execute("SELECT * FROM request WHERE host_id = '" + str(host_id) + "';")
    rows = cursor.fetchall()

    if( rows == []):
        return JsonResponse({})
    response = {"driver_ids": []}
    for row in rows:
        response["driver_ids"].append(row[0])
    return JsonResponse(response)

@csrf_exempt
def getActivities(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    user_id = request.GET.get('user_id')
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM activity WHERE host_id = '" +str(user_id) + "' or driver_id = '" + str(user_id) + "';")
    rows = cursor.fetchall()
    new_list = []
    if( rows == []):
        return JsonResponse({"activities": []})
    for row in rows:
        new_list.append({
	 "host_id": row[0],
	 "driver_id": row[1],
	 "duration": row[2],
	 "cost": row[3]
	})
    response = {"activities": new_list}

    return JsonResponse(response)

# -------------------------POST FUNCTIONS-------------------------
@csrf_exempt
def postUser(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    first_name = json_data['first_name']
    username = json_data['username']
    last_name = json_data['last_name']
    password = json_data['password']
    year_of_birth = json_data['year_of_birth']
    month_of_birth = json_data['month_of_birth']
    day_of_birth = json_data['day_of_birth']
    charging_since = json_data['charging_since']
    description = json_data['description']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO users (first_name, last_name, year_of_birth, month_of_birth, day_of_birth, username, password, charging_since, description) VALUES '
                   '(%s, %s, %s, %s, %s, %s, %s, %s, %s);', (first_name, last_name, year_of_birth, month_of_birth, day_of_birth, username, password, charging_since, description))
    except IntegrityError:
        return JsonResponse({"error": "duplicate entry"})

    cursor.execute("SELECT user_id FROM users u WHERE u.username = '" + str(username)+ "';")
    rows = cursor.fetchone()
    response = {"user_id": rows[0]}
    user_id = str(response['user_id'])

    return JsonResponse(response)

@csrf_exempt
def postUser2(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    # loading multipart/form-data
    first_name = request.POST.get('first_name')
    username = request.POST.get('username')
    last_name = request.POST.get('last_name')
    password = request.POST.get('password')
    year_of_birth = request.POST.get('year_of_birth')
    month_of_birth = request.POST.get('month_of_birth')
    day_of_birth = request.POST.get('day_of_birth')
    charging_since = request.POST.get('charging_since')
    description = request.POST.get('description')

    if request.FILES.get("img_url"):
        content = request.FILES['img_url']
        filename = str(username)+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageurl = fs.url(filename)
    else:
        imageurl = None

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO users (first_name, last_name, year_of_birth, month_of_birth, day_of_birth, username, password, charging_since, description, image_url) VALUES '
                   '(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);', (first_name, last_name, year_of_birth, month_of_birth, day_of_birth, username, password, charging_since, description, imageurl))
    except IntegrityError:
        return JsonResponse({"error": "Integrity error. Its likeley that this user already exists"})

    cursor.execute("SELECT user_id FROM users u WHERE u.username = '" + str(username)+ "';")
    rows = cursor.fetchone()
    response = {"user_id": rows[0]}
    user_id = str(response['user_id'])

    return JsonResponse(response)

@csrf_exempt
def postCharger(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    user_id = json_data['user_id']
    available = json_data['available']
    start_time_availability = json_data['start_time_availability']
    end_time_availability = json_data['end_time_availability']
    charger_type = json_data['charger_type']
    price = json_data['price']
    street_address = json_data['street_address']
    city_address = json_data['city_address']
    state_address = json_data['state_address']
    zipcode_address = json_data['zipcode_address']
    latitude = json_data['latitude']
    longitude = json_data['longitude']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO chargers (user_id,  available, start_time_availability, end_time_availability, charger_type, price, street_address, city_address, state_address, zipcode_address, latitude, longitude ) VALUES '
            '(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);', (user_id, available, start_time_availability, end_time_availability, charger_type, price, street_address, city_address, state_address, zipcode_address, latitude, longitude))
    except IntegrityError:
        return JsonResponse({"error": "duplicate entry"})

    cursor.execute("SELECT cid FROM chargers WHERE user_id = '" +str(user_id) + "' and street_address = '" + str(street_address) + "';")
    rows = cursor.fetchone()
    response = {"cid": rows[0]}
    return JsonResponse(response)

@csrf_exempt
def postChargesAt(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    user_id = json_data['user_id']
    cid = json_data['cid']
    start_time = json_data['start_time']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO charges_at (user_id, cid, start_time) VALUES ''(%s, %s, %s);', (user_id, cid, start_time))
    except IntegrityError:
        return JsonResponse({"error": "duplicate entry"})
    return JsonResponse({})

@csrf_exempt
def postReview(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    review_date = json_data['review_date']
    stars = json_data['stars']
    subject = json_data['subject']
    message = json_data['message']
    receiving_review_type = json_data['receiving_review_type']
    host_id = json_data['host_id']
    driver_id = json_data['driver_id']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO reviews (review_date, stars, subject, message, receiving_review_type, host_id, driver_id) VALUES '
                   '(%s, %s, %s, %s, %s, %s, %s);', (review_date,
                       stars, subject, message, receiving_review_type, host_id,
                       driver_id))
    except IntegrityError:
        return JsonResponse({"error": "duplicate entry"})

    return JsonResponse({})

@csrf_exempt
def postChargerPhoto(request):
    if request.method != 'POST':
        return HttpResponse(status=400)

    # loading multipart/form-data
    cid = request.POST.get("cid")
    user_id = request.POST.get("user_id")

    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = str(user_id)+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageurl = fs.url(filename)
    else:
        imageurl = None

    cursor = connection.cursor()
    cursor.execute('INSERT INTO photos (img_url, cid) VALUES '
                   '(%s, %s);', (imageurl, cid))

    return JsonResponse({})

@csrf_exempt
def postDrive(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    driver_id = json_data['driver_id']
    lics_number = json_data['lics_number']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO drives (lics_number, driver_id) VALUES '
                   '(%s, %s);', (lics_number, driver_id))
    except IntegrityError:
        return JsonResponse({"error": "either a duplicate entry or vehicle is not in our database"})


    return JsonResponse({})

@csrf_exempt
def postVehicle(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    user_id = json_data['user_id']
    lics_number = json_data['lics_number']
    model = json_data['model']
    color = json_data['color']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO vehicle (user_id, lics_number, model, color) VALUES '
                   '(%s, %s, %s, %s);', (user_id, lics_number, model, color))
    except IntegrityError:
        return JsonResponse({"error": "duplicate entry, vehicle is already in database"})


    return JsonResponse({})

@csrf_exempt
def postRequest(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    user_id = json_data['user_id']
    charger_id = json_data['cid']
    host_id = json_data['host_id']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO request (user_id, cid, host_id) VALUES '
                   '(%s, %s, %s);', (user_id, charger_id, host_id))
    except IntegrityError:
        return JsonResponse({"error": "Integrity error"})


    return JsonResponse({})

@csrf_exempt
def postChargerUpdate(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)

    charger_id = json_data['cid']
    host_id = json_data['host_id']

    cursor = connection.cursor()
    try:
        cursor.execute('DELETE FROM request WHERE cid= ' + str(charger_id) + 'AND host_id=' + str(host_id) + ';')
    except IntegrityError:
        return JsonResponse({"error": "Integrity error"})

    cursor.execute("UPDATE chargers SET available = 'FALSE' WHERE cid = "+ str(charger_id) + ";")

    return JsonResponse({})

@csrf_exempt
def postChargerAvailability(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)

    charger_id = json_data['cid']

    cursor = connection.cursor()
    cursor.execute("UPDATE chargers SET available = 'TRUE' WHERE cid = "+ str(charger_id) + ";")

    return JsonResponse({})

@csrf_exempt
def postActivity(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    host_id = json_data['host_id']
    driver_id = json_data['driver_id']
    duration = json_data['duration']
    cost = json_data['cost']

    cursor = connection.cursor()
    try:
        cursor.execute('INSERT INTO activity (host_id, driver_id, duration, cost) VALUES '
                   '(%s, %s, %s, %s);', (host_id, driver_id, duration, cost))
    except IntegrityError:
        return JsonResponse({"error": "Integrity error"})


    return JsonResponse({})
