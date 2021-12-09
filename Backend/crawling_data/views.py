# Create your views here.
from django.shortcuts import render
from rest_framework.response import Response
from .models import ReviewData
from .models import BuildingData
from rest_framework.views import APIView
from .serializers import ReviewSerializer
from .serializers import BuildingSerializer
from django.shortcuts import render, get_object_or_404
from .apps import PororoConfig

class BuildingInfoAPI(APIView):
    def get(self, request):
        queryset = BuildingData.objects.all()
        serializer = BuildingSerializer(queryset, many=True)
        return Response(serializer.data)

class ReviewListAPI(APIView):
    def get(self, request, slug):
        queryset = ReviewData.objects.all()
        serializer = ReviewSerializer(queryset, many=True)
        new_review = PororoConfig.analysis(serializer.data)
        return Response(new_review)
