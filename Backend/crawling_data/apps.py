from django.apps import AppConfig
from pororo import Pororo
from hanspell import spell_checker
import pandas as pd
from konlpy.tag import Mecab

class CrawlingDataConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'crawling_data'

class PororoConfig(AppConfig):
    # pororo 모델 생성
    mecab = Mecab(dicpath=r"C:\mecab\mecab-ko-dic") # 토크나이저

    def getPositivity(input):
        sa = Pororo(task="sentiment", model="brainbert.base.ko.shopping", lang="ko") # 긍부정분석
        zsl = Pororo(task="zero-topic", lang="ko") # 주제분석
        new_list = list()
        for row in input:
            review = dict()
            review_content = row['review_content']
            checked_review = spell_checker.check(review_content)
            clean_review = checked_review.checked
            review['id'] = row['id']
            review['building_name'] = row['building_name']
            review['review_content'] = review_content
            review['checked_review'] = clean_review
            review['star_num'] = row['star_num']
            review['positivity'] = sa(review_content,show_probs=True)
            review['attribute'] = zsl(review_content, ["음식","온도","청결","분위기","친절","만족도","가격"])
            new_list.append(review)
        return new_list

    
    
