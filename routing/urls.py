"""routing URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from app import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('getUser/', views.getUser, name='getUser'),
    path('getUser2/', views.getUser2, name='getUser2'),
    path('postUser/', views.postUser, name='postUser'),
    path('postUser2/', views.postUser2, name='postUser2'),
    path('postDrive/', views.postDrive, name='postDrive'),
    path('getAddCharger/', views.getAddCharger, name='getAddCharger'),
    path('getChargerWindow/', views.getChargerWindow, name='getChargerWindow'),
    path('getChargerInfo/', views.getChargerInfo, name='getChargerInfo'),
    path('postCharger/', views.postCharger, name='postCharger'),
    path('getLocalChargers/', views.getLocalChargers, name='getLocalChargers'),
    path('getAverageReview/', views.getAverageReview, name='getAverageReview'),
    path('postChargesAt/', views.postChargesAt, name='postChargesAt'),
    path('postChargerUpdate/', views.postChargerUpdate, name='postChargerUpdate'),
    path('getReview/', views.getReview, name='getReview'),
    path('getDriverReview/', views.getDriverReview, name='getDriverReview'),
    path('getHostReview/', views.getHostReview, name='getHostReview'),
    path('postReview/', views.postReview, name='postReview'),
    path('getChargerPhotos/', views.getChargerPhotos, name='getChargerPhotos'),
    path('postChargerPhoto/', views.postChargerPhoto, name='postChargerPhoto'),
    path('getVehicle/', views.getVehicle, name='getVehicle'),
    path('postVehicle/', views.postVehicle, name='postVehicle'),
    path('getLogin/', views.getLogin, name='getLogin'),
    path('getRequest/', views.getRequest, name='getRequest'),
    path('postRequest/', views.postRequest, name='postRequest'),
    path('postChargerAvailability/', views.postChargerAvailability, name='postChargerAvailability'),
    path('postActivity/', views.postActivity, name='postActivity'),
    path('getActivities/', views.getActivities, name='getActivities')
]
