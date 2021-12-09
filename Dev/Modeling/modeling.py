from pororo import Pororo
from hanspell import spell_checker
import pandas as pd
from konlpy.tag import Mecab

# open file
df = pd.read_csv('sample.csv')

# sampling
total_review = df[['리뷰']]
sample_review = total_review.iloc[[0, 1, 119, 124, 200, 205, 229]] # sample review's row
print(sample_review)
# pororo 모델 생성
sa = Pororo(task="sentiment", model="brainbert.base.ko.shopping", lang="ko") # 긍부정
#rating = Pororo(task="review", lang="ko") # 점수 예측
mecab = Mecab(dicpath=r"C:\mecab\mecab-ko-dic") # 토크나이저
zsl = Pororo(task="zero-topic", lang="ko")
#dp = Pororo(task="dep_parse", lang="ko") # 구문 분석(mecab 설치 오류로 보류)
#summ = Pororo(task="summarization", model="bullet", lang="ko") # 요약 (runtime error 보류)

for row in sample_review.iterrows():
    review = row[1]
    print("원본 : " + review[0])

    # 맞춤법 교정
    checked_review = spell_checker.check(review)
    review = checked_review.checked
    print("맞춤법 교정 : "+review)

    # 긍부정 분석
    print(sa(review, show_probs=True)) # 긍부정 비율
    print(sa(review)) # 긍부정 판단

    # 점수 예측
    #print(rating(review)) # 예상 점수

    # 형태소 분석
    #print(mecab.morphs(review)) # 토큰화
    #print(mecab.pos(review)) # 품사 태깅

    # 주제 분석
    print(zsl(review, ["음식","온도","청결","분위기","친절","만족도","가격"]))

    print()
 
    


    